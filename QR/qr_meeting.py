import qrcode
from datetime import datetime, timedelta

# Data and expiration
url = "https://docs.google.com/forms/d/e/1FAIpQLSfjDVXGjh6vU8hj-9ezgwcrpO4bh-7-q8s6jDZ6R5g0qyoWZw/viewform"


import qrcode
from PIL import Image, ImageDraw, ImageFont
from datetime import datetime, timedelta

# ==== 1) Config ====
data = "https://example.com/register"
expire_date = datetime.now() + timedelta(days=365)
encoded_text = f"{url}?expires={expire_date.date()}"

# ==== 2) Generate QR ====
qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_H,
    box_size=10,
    border=4,
)
qr.add_data(encoded_text)
qr.make(fit=True)
qr_img = qr.make_image(fill_color="black", back_color="white").convert("RGB")

# ==== 3) Add text below ====
# Create a new image with extra space for text
text = "Scan and register"
font_size = 40
font = ImageFont.truetype("arial.ttf", font_size)  # use a common font

# Calculate sizes
qr_width, qr_height = qr_img.size
draw = ImageDraw.Draw(qr_img)
text_width = draw.textlength(text, font=font)
text_height = font.getbbox(text)[3]

# New canvas with space below
padding = 40
total_height = qr_height + text_height + padding
new_img = Image.new("RGB", (qr_width, total_height), "white")
new_img.paste(qr_img, (0, 0))

# Draw text centered
draw = ImageDraw.Draw(new_img)
text_x = (qr_width - text_width) // 2
text_y = qr_height + (padding // 2)
draw.text((text_x, text_y), text, fill="black", font=font)

# ==== 4) Save ====
new_img.save("qr_scan_register.png")
print(f"✅ QR generated successfully (expires {expire_date.date()})")