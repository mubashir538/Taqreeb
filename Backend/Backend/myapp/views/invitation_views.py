import json
import os
import difflib
import random
from .. import models as m
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
            style_dir = os.path.join(self.fonts_dir, style)
            if os.path.exists(style_dir):
                for font_file in os.listdir(style_dir):
                    if font_file.lower().endswith(('.otf', '.ttf')):
                        font_path = os.path.join(style_dir, font_file)
                        try:
                            font = ImageFont.truetype(
                                font_path, 
                                self.fonts[style]['size']
                            )
                            self.fonts[style]['fonts'].append({
                                'name': font_file,
                                'object': font
                            })
                        except Exception as e:
                            print(f"Failed to load font {font_path}: {str(e)}")
            
            if not self.fonts[style]['fonts']:
                fallback_font = "arialbd.ttf" if 'bold' in style else "arial.ttf"
                self.fonts[style]['fonts'].append({
                    'name': fallback_font,
                    'object': ImageFont.truetype(
                        fallback_font,
                        self.fonts[style]['size']
                    )
                })
                print(f"Using fallback font for {style}")

    def _select_fonts_for_categories(self):
        """Select random fonts for each category that will be used throughout the invitation"""
        for style in self.fonts.keys():
            if self.fonts[style]['fonts']:
                self.fonts[style]['selected_font'] = random.choice(self.fonts[style]['fonts'])['object']
            else:
                fallback_font = "arialbd.ttf" if 'bold' in style else "arial.ttf"
                self.fonts[style]['selected_font'] = ImageFont.truetype(
                    fallback_font,
                    self.fonts[style]['size']
                )

    def _get_font(self, style):
        """Get the pre-selected font for the specified style"""
        return self.fonts.get(style, {}).get('selected_font', ImageFont.truetype("arial.ttf", 42))

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
        
    def _calculate_text_block_height(self, text, font_style, max_width, img_width):
        """Calculate the height needed for a block of text"""
        font = self._get_font(font_style)
        lines = text.split('\n')
        total_height = 0
        
        for line in lines:
            if not line.strip():
                total_height += font.size
                continue
                
            text_width = font.getlength(line)
            if max_width and text_width > max_width:
                words = line.split()
                current_line = []
                
                for word in words:
                    test_line = ' '.join(current_line + [word])
                    test_width = font.getlength(test_line)
                    
                    if test_width <= max_width:
                        current_line.append(word)
                    else:
                        if current_line:
                            total_height += int(font.size * 1.5)
                        current_line = [word]
                
                if current_line:
                    total_height += int(font.size * 1.5)
            else:
                total_height += int(font.size * 1.5)
                
        return total_height

    def _draw_centered_text(self, draw, text, y_position, font_style, color, img_width, safe_zones, max_width=None):
        """Draw centered text within safe zones"""
        font = self._get_font(font_style)
        lines = text.split('\n')
        
        safe_left = safe_zones['xStart'] * img_width
        safe_right = safe_zones['xEnd'] * img_width
        safe_width = safe_right - safe_left
        
        available_width = min(max_width, safe_width) if max_width else safe_width
        
        for line in lines:
            if not line.strip():
                y_position += font.size
                continue
                
            text_width = font.getlength(line)
            
            if available_width and text_width > available_width:
                words = line.split()
                current_line = []
                
                for word in words:
                    test_line = ' '.join(current_line + [word])
                    test_width = font.getlength(test_line)
                    
                    if test_width <= available_width:
                        current_line.append(word)
                    else:
                        if current_line:
                            wrapped_line = ' '.join(current_line)
                            wrapped_width = font.getlength(wrapped_line)
                            x_position = safe_left + (safe_width - wrapped_width) / 2
                            draw.text((x_position, y_position), wrapped_line, fill=color, font=font)
                            y_position += int(font.size * 1.5)
                        current_line = [word]
                
                if current_line:
                    remaining_line = ' '.join(current_line)
                    remaining_width = font.getlength(remaining_line)
                    x_position = safe_left + (safe_width - remaining_width) / 2
                    draw.text((x_position, y_position), remaining_line, fill=color, font=font)
                    y_position += int(font.size * 1.5)
            else:
                x_position = safe_left + (safe_width - text_width) / 2
                draw.text((x_position, y_position), line, fill=color, font=font)
                y_position += int(font.size * 1.5)
                
            if font_style == 'bold2' and 'extra_space' in self.fonts[font_style]:
                y_position += self.fonts[font_style]['extra_space']
                
        return y_position

    def generate_invitation(self):
        try:
            bg_path, template_config = self._select_background_and_config()
            img = Image.open(bg_path).convert("RGB")
            draw = ImageDraw.Draw(img)
            width, height = img.size

            primary_color = template_config['color1']
            secondary_color = template_config['color2']
            safe_zones = template_config['safe_zones']

            padding = width * 0.03 
            safe_left = safe_zones['xStart'] * width + padding
            safe_right = safe_zones['xEnd'] * width - padding
            safe_top = safe_zones['yStart'] * height + padding
            safe_bottom = safe_zones['yEnd'] * height - padding
            safe_width = safe_right - safe_left
            safe_height = safe_bottom - safe_top

            event_type = self.data.get('eventType', 'Wedding')
            function_type = self.data.get('functionType', 'Wedding')
            basic_info = self.data.get('basicInfo', {})

            sections = []

            if event_type == 'Wedding':
                so = difflib.SequenceMatcher(None, basic_info['s/o'], basic_info['hostName']).ratio()
                do = difflib.SequenceMatcher(None, basic_info['d/o'], basic_info['hostName']).ratio()
                if so > do:
                    bride_and_groom = [
                        (f"{basic_info.get('name1', 'Groom')}", 'script', primary_color),
                        ("With", 'bold2', primary_color),
                        (f"{basic_info.get('name2', 'Bride')}", 'script', primary_color),
                        (f"{basic_info.get('d/o', '')}", 'regular', primary_color),
                    ]
                else:
                    bride_and_groom = [
                        (f"{basic_info.get('name2', 'Bride')}", 'script', primary_color),
                        ("With", 'bold2', primary_color),
                        (f"{basic_info.get('name1', 'Groom')}", 'script', primary_color),
                        (f"{basic_info.get('s/o', '')}", 'regular', primary_color),
                    ]

                main_sections = [
                    ("In the Name of Allah,\nthe Most Gracious, the Most Merciful", 'regular', primary_color),
                    (f"Mr. & Mrs. {basic_info.get('hostName', 'Host Family')}", 'bold1', primary_color),
                    ("Request the honor of your presence", 'regular', primary_color),
                    (f"at the {function_type} of their beloved", 'regular', primary_color),
                    *bride_and_groom,
                    ("", 'regular', primary_color),
                    (f"On {self._format_date(basic_info.get('date', ''))}", 'bold2', primary_color),
                    (f"At {self.data.get('venueName', 'At Home')}", 'bold2', secondary_color),
                    (basic_info.get('location', ''), 'regular', secondary_color)
                ]
            elif event_type == 'Birthday':
                main_sections = [
                    ("Join us in celebrating with", 'regular', primary_color),
                    (f"Mr. & Mrs. {basic_info.get('hostName', 'Host Family')}", 'bold1', primary_color),
                    (f"on the Birthday Celebration of", 'regular', primary_color),
                    (f"{basic_info.get('name1', 'Child')}", 'script', primary_color),
                    (f"", 'bold1', primary_color),
                    (f"On {self._format_date(basic_info.get('date', ''))}", 'bold2', primary_color),
                    (f"At {self.data.get('venueName', 'At Our House')}", 'bold2', secondary_color),
                    (basic_info.get('location', ''), 'regular', secondary_color)
                ]
            elif event_type == 'Corporate Event':
                main_sections = [
                    (f"The partners of {basic_info.get('hostName', 'Company')} and Co. would like to", 'regular', primary_color),
                    ("Cordially invite you to", 'regular', primary_color),
                    (f"Annual", 'bold1', primary_color),
                    (f"{basic_info.get('name1', 'Event')}", 'bold2', primary_color),
                    (f"", 'bold1', primary_color),
                    (f"Please Join Us for a day of Networking", 'regular', primary_color),
                    (f"Collaboration and Celebration as we come", 'regular', primary_color),
                    (f"to Propel our Company Forward", 'regular', primary_color),
                    (f"", 'bold1', primary_color),
                    (f"On {self._format_date(basic_info.get('date', ''))}", 'bold2', primary_color),
                    (f"At {self.data.get('venueName', 'At Our House')}", 'bold2', secondary_color),
                    (basic_info.get('location', ''), 'regular', secondary_color)
                
                ]
            elif event_type == 'Religious Event':
                main_sections = [
                    ("Celebrate", 'regular', primary_color),
                    (f"{basic_info.get('name1', 'Event')}", 'bold2', primary_color),
                    (f"with", 'regular', primary_color),
                    (f"{basic_info.get('hostName', 'Our Family')}", 'bold1', primary_color),
                    (f"", 'bold1', primary_color),
                    (f"On {self._format_date(basic_info.get('date', ''))}", 'bold1', primary_color),
                    (f"At {self.data.get('venueName', 'At Our House')}", 'bold1', secondary_color),
                    (basic_info.get('location', ''), 'regular', secondary_color)
                ]
            else:
                main_sections = [
                    ("Let's Celebrate", 'regular', primary_color),
                    (f"{basic_info.get('name1', 'Event')}", 'bold2', primary_color),
                    (f"with", 'regular', primary_color),
                    (f"{basic_info.get('hostName', 'Our Family')}", 'bold1', primary_color),
                    (f"Don't Miss It", 'regular', primary_color),
                    (f"", 'bold1', primary_color),
                    (f"On {self._format_date(basic_info.get('date', ''))}", 'bold2', primary_color),
                    (f"At {self.data.get('venueName', 'At Our House')}", 'bold2', secondary_color),
                    (basic_info.get('location', ''), 'regular', secondary_color)
                ]
            sections.extend(main_sections)

            main_content_height = 0
            for text, font_style, _ in main_sections:
                main_content_height += self._calculate_text_block_height(
                    text, font_style, safe_width, width
                )

            program_details = self.data.get('programDetails', [])
            contact_info = self.data.get('contactInfo', [])

            program_height = 0
            contact_height = 0

            if program_details:
                program_header = "Program"
                program_height += self._calculate_text_block_height(program_header, 'bold1', safe_width/2, width)

                program_text = "\n".join([f"{item.get('name', 'Event')}: {item.get('time', '')}" 
                                      for item in program_details])
                program_height += self._calculate_text_block_height(program_text, 'regular', safe_width/2, width)

            if contact_info:
                contact_header = "R.S.V.P"
                contact_height += self._calculate_text_block_height(contact_header, 'bold1', safe_width/2, width)

                contact_lines = []
                for contact in contact_info:
                    if ":" in contact:
                        name, number = contact.split(":", 1)
                        contact_lines.append(f"{name}:")
                        contact_lines.append(number.strip())
                    else:
                        contact_lines.append(contact)
                contact_text = "\n".join(contact_lines)
                contact_height += self._calculate_text_block_height(contact_text, 'regular', safe_width/2, width)

            total_content_height = main_content_height + max(program_height, contact_height)

            y_start = safe_top + (safe_height - total_content_height) / 2
            y_position = y_start

            for text, font_style, color in main_sections:
                y_position = self._draw_centered_text(
                    draw, text, y_position, font_style, color, 
                    width, safe_zones, safe_width
                )

            if program_details or contact_info:
                if program_details and contact_info:
                        column_gap = padding * 2 
                        program_font = self._get_font('regular')
                        contact_font = self._get_font('regular')
                        max_program_text = max([draw.textlength(f"{i.get('name', '').capitalize()} ...... {i.get('time', '')}", font=program_font) for i in program_details], default=0)
                        max_contact_text = 0
                        for c in contact_info:
                            if ":" in c:
                                name, number = c.split(":", 1)
                                name_width = draw.textlength(f"{name}:", font=contact_font)
                                number_width = draw.textlength(number.strip(), font=contact_font)
                                max_contact_text = max(max_contact_text, name_width, number_width)
                            else:
                                max_contact_text = max(max_contact_text, draw.textlength(c, font=contact_font))

                        column_gap = padding * 2
                        true_combined_width = max_program_text + column_gap + max_contact_text

                        program_height = self._calculate_section_height(program_details, column_gap)
                        contact_height = self._calculate_section_height(contact_info, column_gap)
                        max_height = max(program_height, contact_height)

                        start_x = safe_left + (safe_width - true_combined_width) / 2  
                        start_y = y_position + (safe_bottom - y_position - max_height) / 2
                        program_x = start_x
                        program_y = start_y
                        program_header = "Program"
                        program_header_font = self._get_font('bold1')
                        draw.text((program_x, program_y), program_header, 
                                 fill=primary_color, font=program_header_font)
                        program_y += program_header_font.size + 20
                        program_font = self._get_font('regular')
                        program_font_size = max(program_font.size - 4, 24)
                        try:
                            program_font = ImageFont.truetype(program_font.path, program_font_size)
                        except:
                            program_font = ImageFont.truetype("arial.ttf", program_font_size)

                        for item in program_details:
                            program_text = f"{item.get('name', 'Event')} ...... {item.get('time', '')}"
                            draw.text((program_x, program_y), program_text, 
                                     fill=secondary_color, font=program_font)
                            program_y += program_font.size + 10

                        contact_x = program_x + max_program_text + column_gap
                        contact_y = start_y

                        contact_header = "R.S.V.P"
                        contact_header_font = self._get_font('bold1')
                        draw.text((contact_x, contact_y), contact_header, 
                                 fill=primary_color, font=contact_header_font)
                        contact_y += contact_header_font.size + 20

                        contact_font = self._get_font('regular')
                        contact_font_size = max(contact_font.size - 4, 24)
                        try:
                            contact_font = ImageFont.truetype(contact_font.path, contact_font_size)
                        except:
                            contact_font = ImageFont.truetype("arial.ttf", contact_font_size)

                        for contact in contact_info:
                            if ":" in contact:
                                name, number = contact.split(":", 1)
                                draw.text((contact_x, contact_y), f"{name}:", 
                                         fill=secondary_color, font=contact_font)
                                contact_y += contact_font.size + 5

                                draw.text((contact_x + 20, contact_y), number.strip(), 
                                         fill=secondary_color, font=contact_font)
                                contact_y += contact_font.size + 10
                            else:
                                draw.text((contact_x, contact_y), contact, 
                                         fill=secondary_color, font=contact_font)
                                contact_y += contact_font.size + 10

                        y_position = start_y + max_height
            
                else:
                    section_content = program_details or contact_info
                    section_title = "Program" if program_details else "Contact"
                    
                    section_height = self._calculate_section_height(section_content, safe_width)
                    start_y = y_position + (safe_bottom - y_position - section_height) / 2
                    
                    section_header_font = self._get_font('bold1')
                    section_header_width = section_header_font.getlength(section_title)
                    section_header_x = safe_left + (safe_width - section_header_width) / 2
                    draw.text((section_header_x, start_y), section_title, 
                             fill=primary_color, font=section_header_font)
                    current_y = start_y + section_header_font.size + 20
                    
                    section_font = self._get_font('regular')
                    section_font_size = max(section_font.size - 4, 24)
                    try:
                        section_font = ImageFont.truetype(section_font.path, section_font_size)
                    except:
                        section_font = ImageFont.truetype("arial.ttf", section_font_size)
                    
                    if program_details:
                        for item in program_details:
                            program_text = f"{item.get('name', 'Event')}: {item.get('time', '')}"
                            draw.text((safe_left, current_y), program_text, 
                                     fill=secondary_color, font=section_font)
                            current_y += section_font.size + 10
                    else:
                        for contact in contact_info:
                            if ":" in contact:
                                name, number = contact.split(":", 1)
                                draw.text((safe_left, current_y), f"{name}:", 
                                         fill=secondary_color, font=section_font)
                                current_y += section_font.size + 5
                                
                                draw.text((safe_left + 20, current_y), number.strip(), 
                                         fill=secondary_color, font=section_font)
                                current_y += section_font.size + 10
                            else:
                                draw.text((safe_left, current_y), contact, 
                                         fill=secondary_color, font=section_font)
                                current_y += section_font.size + 10
                    
                    y_position = current_y
            relative_path = f"uploads/tempCards/{self.data['uid']}/Card_{event_type}.png"

            filestorage = FileSystemStorage()

            full_path = os.path.join(filestorage.location, relative_path)

            os.makedirs(os.path.dirname(full_path), exist_ok=True)
            img.save(full_path)
            path = filestorage.save(relative_path, open(full_path, 'rb'))
            return filestorage.url(path) 
        except Exception as e:
            print(f"Error generating invitation: {str(e)}")
            return None

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
        
        if isinstance(items, list) and all(isinstance(item, dict) for item in items):
            for item in items:
                text = f"{item.get('name', 'Event')}: {item.get('time', '')}"
                height += self._calculate_text_height(text, content_font, max_width)
        else:
            for contact in items:
                if ":" in contact:
                    name, number = contact.split(":", 1)
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

class DeleteOldTempCardsCronJob(CronJobBase):
    RUN_EVERY_MINS = 60 

    schedule = Schedule(run_every_mins=RUN_EVERY_MINS)
    code = 'myapp.delete_old_temp_cards' 

    def do(self):
        cutoff = timezone.now() - timedelta(hours=24)
        old_cards = m.TempInvitationCard.objects.filter(created_at__lt=cutoff)
        for card in old_cards:
            card.delete()