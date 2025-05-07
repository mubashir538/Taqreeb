import json
import os
import random
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.conf import settings
from django.core.files.storage import FileSystemStorage
from PIL import Image, ImageDraw, ImageFont
from django_cron import CronJobBase, Schedule
from datetime import timedelta
from django.utils import timezone
from datetime import datetime
from ..constants.views_constants import arial_font
from ..models.misc_models import TempInvitationCard

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def get_invitation_details(request):
    data = request.data
    template_id = data.get('templateId')  
    userid = data['uid']
    eventtype = data['eventType']
    date = data['basicInfo']['date']
    location = data['basicInfo']['location']
    hostname = data['basicInfo']['hostName']
    if eventtype == 'Wedding':
        name = data['basicInfo']['name1']
        bride = data['basicInfo']['name2']
        son = data['basicInfo']['s/o']
        daughter = data['basicInfo']['d/o']
    elif eventtype == 'Birthday':
        name = data['basicInfo']['name1']
    else:
        name = data['basicInfo']['name1']
    contact_info = data['contactInfo'] 

    data2 = {
    "eventType": eventtype,
    'functionType': data['functionType'].capitalize(),
    "basicInfo": {
        "date": date,
        "location": location,
        "hostName": hostname.capitalize(),
        "name1": name.capitalize(),
        "name2": bride.capitalize(),
        "s/o": f"S/O. {son.capitalize()}",
        "d/o": f"D/O. {daughter.capitalize()}"
    },
    'uid': userid,
    "contactInfo": [f"{i['name'].capitalize()}: {i['number']}" for i in contact_info]
}
    if data['programDetails']:
        data2['programDetails'] = data['programDetails']
    if data['venueName']:
        data2['venueName'] = data['venueName']

    generator = InvitationGenerator(data2, template_id) 
    cardurl = generator.generate_invitation()

    return Response({'status':'success','TempCard':cardurl})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_available_templates(request):
    event_type = request.GET.get('eventType', 'Wedding')
    bg_dir = os.path.join(settings.MEDIA_ROOT, 'InvitationBackground', event_type)
    
    templates = []
    if os.path.exists(bg_dir):
        png_files = [f for f in os.listdir(bg_dir) if f.lower().endswith('.png')]
        
        for png_file in png_files:
            base_name = os.path.splitext(png_file)[0]
            json_file = f"{base_name}.json"
            
            json_exists = os.path.exists(os.path.join(bg_dir, json_file))
            
            templates.append({
                'id': base_name,
                'imageUrl': os.path.join(settings.MEDIA_URL, 'InvitationBackground', event_type, png_file),
                'hasConfig': json_exists
            })
    
    return Response({'status': 'success', 'templates': templates})

class InvitationGenerator:
    def __init__(self, data,template_id=None):
        self.data = data
        self.template_id = template_id 
        media_storage = FileSystemStorage(location=settings.MEDIA_ROOT)
        self.backgrounds_dir = os.path.join(media_storage.location, 'InvitationBackground')
        self.fonts_dir = os.path.join(media_storage.location, 'FontStyles')

        self.fonts = {
            'bold1': {'size': 54, 'fonts': [], 'selected_font': None},
            'bold2': {'size': 44, 'fonts': [], 'selected_font': None, 'extra_space': 10},
            'regular': {'size': 32, 'fonts': [], 'selected_font': None},
            'script': {'size': 92, 'fonts': [], 'selected_font': None}
        }
        
        self._load_fonts_from_structure()
        
        self._select_fonts_for_categories()

    def _load_fonts_from_structure(self):
        """Load fonts from the organized folder structure"""
        for style in self.fonts.keys():
            self._load_fonts_for_style(style)


    def _load_fonts_for_style(self, style):
        style_dir = os.path.join(self.fonts_dir, style)
        font_files = self._get_font_files_for_style(style_dir)

        for font_file in font_files:
            font_path = os.path.join(style_dir, font_file)
            font_obj = self._load_font_object(font_path, self.fonts[style]['size'])
            if font_obj:
                self.fonts[style]['fonts'].append({
                    'name': font_file,
                    'object': font_obj
                })

        if not self.fonts[style]['fonts']:
            self._load_fallback_font(style)


    def _get_font_files_for_style(self, style_dir):
        if not os.path.exists(style_dir):
            return []
        return [f for f in os.listdir(style_dir) if f.lower().endswith(('.otf', '.ttf'))]


    def _load_font_object(self, path, size):
        try:
            return ImageFont.truetype(path, size)
        except Exception as e:
            print(f"Failed to load font {path}: {str(e)}")
            return None


    def _load_fallback_font(self, style):
        fallback_font = "arialbd.ttf" if 'bold' in style else arial_font
        try:
            fallback = ImageFont.truetype(fallback_font, self.fonts[style]['size'])
            self.fonts[style]['fonts'].append({
                'name': fallback_font,
                'object': fallback
            })
            print(f"Using fallback font for {style}")
        except Exception as e:
            print(f"Failed to load fallback font {fallback_font}: {str(e)}")


    def _select_fonts_for_categories(self):
        """Select random fonts for each category that will be used throughout the invitation"""
        for style in self.fonts.keys():
            if self.fonts[style]['fonts']:
                self.fonts[style]['selected_font'] = random.choice(self.fonts[style]['fonts'])['object']
            else:
                fallback_font = "arialbd.ttf" if 'bold' in style else arial_font
                self.fonts[style]['selected_font'] = ImageFont.truetype(
                    fallback_font,
                    self.fonts[style]['size']
                )

    def _get_font(self, style):
        """Get the pre-selected font for the specified style"""
        return self.fonts.get(style, {}).get('selected_font', ImageFont.truetype(arial_font, 42))

    def _load_template_config(self, json_path):
        """Load template config from JSON including safe zones"""
        default_config = {
            'color1': '#000000', 
            'color2': '#555555',
            'safe_zones': {
                'xStart': 0.1,
                'xEnd': 0.9,
                'yStart': 0.1,
                'yEnd': 0.9
            }
        }
        
        if not os.path.exists(json_path):
            return default_config
        
        with open(json_path, 'r') as f:
            try:
                config = json.load(f)
                if 'color' in config: 
                    config['color1'] = config['color']
                    config['color2'] = config['color']
                
                if 'safe_zones' in config:
                    safe_zones = config['safe_zones']
                    for key in ['xStart', 'xEnd', 'yStart', 'yEnd']:
                        if key not in safe_zones:
                            safe_zones[key] = default_config['safe_zones'][key]
                    config['safe_zones'] = safe_zones
                else:
                    config['safe_zones'] = default_config['safe_zones']
                
                return {**default_config, **config}
            except Exception as e:
                print(f"Error loading template config: {str(e)}")
                return default_config

    def _select_background_and_config(self):
        event_type = self.data.get('eventType', 'Wedding')
        bg_dir = os.path.join(self.backgrounds_dir, event_type)
        
        if self.template_id:
            image_path = os.path.join(bg_dir, f"{self.template_id}.png")
            if not os.path.exists(image_path):
                raise FileNotFoundError(f"Template {self.template_id} not found")
                
            json_path = os.path.join(bg_dir, f"{self.template_id}.json")
            template_config = self._load_template_config(json_path)
            return image_path, template_config
        else:
            images = [f for f in os.listdir(bg_dir) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
            selected_image = random.choice(images)
            image_path = os.path.join(bg_dir, selected_image)
            
            base_name = os.path.splitext(selected_image)[0]
            json_path = os.path.join(bg_dir, f"{base_name}.json")
            template_config = self._load_template_config(json_path)
            
            return image_path, template_config
        
    def _calculate_text_block_height(self, text, font_style, max_width):
        "Calculate the height needed for a block of text"
        font = self._get_font(font_style)
        lines = text.split('\n')
        total_height = 0

        for line in lines:
            total_height += self._calculate_line_height(line, font, max_width)

        return total_height

    # ----------------- Helper Methods -----------------

    def _calculate_line_height(self, line, font, max_width):
        """Calculate height for a single line or wrapped line"""
        if not line.strip():
            return font.size

        text_width = font.getlength(line)
        if max_width and text_width > max_width:
            return self._calculate_wrapped_line_height(line, font, max_width)
        
        return int(font.size * 1.5)

    def _calculate_wrapped_line_height(self, line, font, max_width):
        """Calculate height for a line that wraps"""
        words = line.split()
        current_line = []
        line_count = 0

        for word in words:
            test_line = ' '.join(current_line + [word])
            test_width = font.getlength(test_line)

            if test_width <= max_width:
                current_line.append(word)
            else:
                if current_line:
                    line_count += 1
                current_line = [word]

        if current_line:
            line_count += 1

        return line_count * int(font.size * 1.5)

    def _draw_centered_text(self, draw, text, y_position, font_style, color, img_width, safe_zones, max_width=None):
        "Draw centered text within safe zones"
        font = self._get_font(font_style)
        safe_left, safe_width, available_width = self._calculate_safe_area(img_width, safe_zones, max_width)
        lines = text.split('\n')

        for line in lines:
            if not line.strip():
                y_position += font.size
                continue

            if font.getlength(line) > available_width:
                y_position = self._draw_wrapped_text(draw, line, font, color, safe_left, safe_width, available_width, y_position)
            else:
                x_position = self._get_center_x(safe_left, safe_width, font.getlength(line))
                draw.text((x_position, y_position), line, fill=color, font=font)
                y_position += int(font.size * 1.5)

            if font_style == 'bold2' and 'extra_space' in self.fonts[font_style]:
                y_position += self.fonts[font_style]['extra_space']

        return y_position

    def _calculate_safe_area(self, img_width, safe_zones, max_width):
        safe_left = safe_zones['xStart'] * img_width
        safe_right = safe_zones['xEnd'] * img_width
        safe_width = safe_right - safe_left
        available_width = min(max_width, safe_width) if max_width else safe_width
        return safe_left, safe_width, available_width

    def _draw_wrapped_text(self, draw, line, font, color, safe_left, safe_width, available_width, y_position):
        words = line.split()
        current_line = []

        for word in words:
            test_line = ' '.join(current_line + [word])
            if font.getlength(test_line) <= available_width:
                current_line.append(word)
            else:
                if current_line:
                    y_position = self._draw_line(draw, ' '.join(current_line), font, color, safe_left, safe_width, y_position)
                current_line = [word]

        if current_line:
            y_position = self._draw_line(draw, ' '.join(current_line), font, color, safe_left, safe_width, y_position)

        return y_position

    def _draw_line(self, draw, text, font, color, safe_left, safe_width, y_position):
        x_position = self._get_center_x(safe_left, safe_width, font.getlength(text))
        draw.text((x_position, y_position), text, fill=color, font=font)
        return y_position + int(font.size * 1.5)

    def _get_center_x(self, safe_left, safe_width, text_width):
        return safe_left + (safe_width - text_width) / 2

    def generate_invitation(self):
        try:
            bg_path, template_config = self._select_background_and_config()
            img = Image.open(bg_path).convert("RGB")
            draw = ImageDraw.Draw(img)
            width, height = img.size

            safe_zones = self._calculate_safe_zone_dimensions(width, height, template_config)
            main_sections = self._build_main_sections(template_config, safe_zones)

            y_position = self._draw_main_sections(draw, main_sections, safe_zones)

            self._draw_program_and_contact_sections(draw, safe_zones, y_position)

            return self._save_image(img, self.data['uid'], self.data.get('eventType', 'Event'))

        except Exception as e:
            print(f"Error generating invitation: {str(e)}")
            return None
    def _calculate_safe_zone_dimensions(self, width, height, config):
        
        padding = width * 0.03
        zones = config['safe_zones']
        return {
            'left': zones['xStart'] * width + padding,
            'right': zones['xEnd'] * width - padding,
            'top': zones['yStart'] * height + padding,
            'bottom': zones['yEnd'] * height - padding,
            'width': (zones['xEnd'] - zones['xStart']) * width - 2 * padding,
            'height': (zones['yEnd'] - zones['yStart']) * height - 2 * padding,
            'primary_color': config['color1'],
            'secondary_color': config['color2'],
            'img_width': width
        }

    def _draw_main_sections(self, draw, sections, safe_zones):
        content_height = self._get_total_content_height(sections, safe_zones)
        y_position = self._calculate_initial_y(safe_zones, content_height)

        for text, style, color in sections:
            y_position = self._draw_section_line(draw, text, style, color, y_position, safe_zones)

        return y_position
    def _get_total_content_height(self, sections, safe_zones):
        return sum(
            self._calculate_text_block_height(text, style, safe_zones['width'])
            for text, style, _ in sections
        )
    def _calculate_initial_y(self, safe_zones, content_height):
        return safe_zones['top'] + (safe_zones['height'] - content_height) / 2

    def _draw_section_line(self, draw, text, style, color, y_position, safe_zones):
        return self._draw_centered_text(
            draw, text, y_position, style, color,
            safe_zones['img_width'],
            {
                'xStart': safe_zones['left'] / safe_zones['img_width'],
                'xEnd': safe_zones['right'] / safe_zones['img_width'],
            },
            max_width=safe_zones['width']
        )

    def _draw_program_and_contact_sections(self, draw, safe_zones, y_position):
        program = self.data.get('programDetails', [])
        contact = self.data.get('contactInfo', [])
        if not program and not contact:
            return

        if program and contact:
            self._draw_two_column_sections(draw, program, contact, safe_zones, y_position)
        else:
            self._draw_single_column_section(draw, program or contact, safe_zones, y_position,
                                            title="Program" if program else "Contact")

    def _save_image(self, img, uid, event_type):
        relative_path = f"uploads/tempCards/{uid}/Card_{event_type}.png"
        storage = FileSystemStorage()
        full_path = os.path.join(storage.location, relative_path)

        os.makedirs(os.path.dirname(full_path), exist_ok=True)
        img.save(full_path)
        path = storage.save(relative_path, open(full_path, 'rb'))
        return storage.url(path)

    def _calculate_section_height(self, items, max_width):
        height = 0
        header_font = self._get_font('bold1')
        height += header_font.size + 20 
        
        content_font = self._get_font('regular')
        content_font_size = max(content_font.size - 4, 24)
        try:
            content_font = ImageFont.truetype(content_font.path, content_font_size)
        except:
            content_font = ImageFont.truetype("arial.ttf", content_font_size)
            raise
        
        if isinstance(items, list) and all(isinstance(item, dict) for item in items):
            for item in items:
                text = f"{item.get('name', 'Event')}: {item.get('time', '')}"
                height += self._calculate_text_height(text, content_font, max_width)
        else:
            for contact in items:
                if ":" in contact:
                    _name, number = contact.split(":", 1)
                    height += content_font.size + 5  
                    height += self._calculate_text_height(number.strip(), content_font, max_width - 20)
                else:
                    height += self._calculate_text_height(contact, content_font, max_width)
        
        return height
    
    def _calculate_text_height(self, text, font, max_width):
        lines = []
        words = text.split()
        
        current_line = []
        for word in words:
            test_line = ' '.join(current_line + [word])
            if font.getlength(test_line) <= max_width:
                current_line.append(word)
            else:
                if current_line:
                    lines.append(' '.join(current_line))
                current_line = [word]
        
        if current_line:
            lines.append(' '.join(current_line))
        
        return len(lines) * (font.size + 10)
    
    def _format_date(self, date_str):
        try:
            date_obj = datetime.strptime(date_str, "%Y-%m-%d")
            dates = date_obj.strftime("%A, %B %d, %Y").split(", ")
            day = dates[1].split(' ')[1]
            if day.endswith('1') and not day.endswith('11'):
                day += 'st'
            elif day.endswith('2') and not day.endswith('12'):
                day += 'nd'
            elif day.endswith('3') and not day.endswith('13'):
                day += 'rd'
            else:
                day += 'th'
            dates[1] = dates[1].split(' ')[0] + ' ' + day
            return ', '.join(dates)
        except:
            return "a special day"
            raise

class DeleteOldTempCardsCronJob(CronJobBase):
    RUN_EVERY_MINS = 60 

    schedule = Schedule(run_every_mins=RUN_EVERY_MINS)
    code = 'myapp.delete_old_temp_cards' 

    def do(self):
        cutoff = timezone.now() - timedelta(hours=24)
        old_cards = TempInvitationCard.objects.filter(created_at__lt=cutoff)
        for card in old_cards:
            card.delete()