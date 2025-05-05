def urlShortener(url):
    try:
        response = rq.get("http://tinyurl.com/api-create.php?url="+url)
        response.raise_for_status()
        return response.text
    except Exception as e:
        print(e)
        return e

def clean_name(name):
    # Remove characters that are not letters or numbers
    return re.sub(r'[^a-zA-Z0-9]', '', name.lower())

def generate_username(first_name, last_name):
    first = clean_name(first_name)
    last = clean_name(last_name)

    # Try base variations
    base_variants = [
        f"{first}{last}",
        f"{first}_{last}",
        f"{first}_{last[:1]}",
        f"{first[:1]}_{last}",
        f"{first[:1]}_{last[:1]}"
    ]

    # Try each variant first
    for variant in base_variants:
        if not m.User.objects.filter(username=variant).exists():
            return variant

    # Fallback: add numbers until a unique one is found
    while True:
        variant = f"{first}_{last}_{rd.randint(100, 9999)}"
        if not m.User.objects.filter(username=variant).exists():
            return variant
        
