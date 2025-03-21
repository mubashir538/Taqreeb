import torch
from diffusers import StableDiffusionPipeline
from ultralytics import YOLO
from transformers import GPT2Tokenizer, GPT2LMHeadModel
import cv2
from PIL import Image, ImageDraw, ImageFont
import numpy as np

# -------------------------------
# 1. Generate Invitation Background (Stable Diffusion)
# -------------------------------

def generate_invitation_background(prompt="Elegant wedding invitation with floral design"):
    print("Generating background...")
    pipe = StableDiffusionPipeline.from_pretrained("runwayml/stable-diffusion-v1-5").to("cuda")
    image = pipe(prompt).images[0]
    image.save("invitation_background.png")
    print("Background saved as invitation_background.png")

# -------------------------------
# 2. Train and Use YOLO for Text Placement
# -------------------------------

def train_yolo():
    print("Training YOLO model...")
    model = YOLO("yolov8n.pt")  # Pretrained YOLO model
    model.train(data="data.yaml", epochs=50, imgsz=640)  # Train on custom dataset
    print("YOLO training completed.")

def detect_text_positions(image_path):
    print("Detecting text placement...")
    model = YOLO("yolov8n.pt")  # Load pretrained model
    results = model(image_path)  # Run detection
    
    if results[0].boxes:
        text_position = results[0].boxes.xyxy[0].tolist()  # Get bounding box
        return text_position
    return [50, 300]  # Default position if detection fails

# -------------------------------
# 3. Generate Invitation Text (GPT-2)
# -------------------------------

def generate_invitation_text():
    print("Generating invitation text...")
    tokenizer = GPT2Tokenizer.from_pretrained("gpt2")
    model = GPT2LMHeadModel.from_pretrained("gpt2")

    input_text = "Generate an elegant wedding invitation message"
    inputs = tokenizer.encode(input_text, return_tensors="pt")
    output = model.generate(inputs, max_length=100)
    
    generated_text = tokenizer.decode(output[0])
    return generated_text

# -------------------------------
# 4. Combine Everything to Create the Invitation
# -------------------------------

def create_invitation():
    print("Creating invitation card...")

    # Step 1: Generate background
    generate_invitation_background()

    # Step 2: Detect text placement
    text_position = detect_text_positions("invitation_background.png")
    
    # Step 3: Generate invitation text
    invitation_text = generate_invitation_text()

    # Step 4: Overlay text on background
    background = Image.open("invitation_background.png")
    draw = ImageDraw.Draw(background)

    font = ImageFont.truetype("arial.ttf", 40)
    x, y = int(text_position[0]), int(text_position[1])
    draw.text((x, y), invitation_text, fill="black", font=font)

    # Save final invitation
    background.save("final_invitation.png")
    print("Invitation saved as final_invitation.png")

# -------------------------------
# Run the full pipeline
# -------------------------------

if __name__ == "__main__":
    create_invitation()
