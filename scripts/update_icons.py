from PIL import Image

foreground = (75, 108, 48)
background = (251, 248, 222)

def replace_color(image, target):
    image_data = list(image.getdata())
    transformed_data = [
        (*target, source[3]) if len(source) == 4 else target
        for source in image_data
    ]
    transformed_image = Image.new(image.mode, image.size)
    transformed_image.putdata(transformed_data)
    return transformed_image

class Asset(object):
    def __init__(self, name: str):
        self.path = f"assets/icons/{name}"
        self.image = Image.open(self.path)
    def __enter__(self):
        return self.image
    def __exit__(self, type, value, traceback):
        self.image.save(self.path)

if __name__ == "__main__":
    with Asset("icon-background.png") as img:
        img.paste(replace_color(img, background))

    with Asset("icon.png") as img:
        img.paste(replace_color(img, foreground))

    with Asset("notification.png") as img:
        img.paste(replace_color(img, foreground))

    with Asset("icon-ios.png") as img:
        img.paste(Image.new("RGBA", img.size, background))
        overlay = Image.open("assets/icons/icon.png")
        img.paste(overlay, (0, 0), overlay)
