import os
import raw_data as r
import random

# because the designs were better when there certain design enhacer like
# cut-outs, I added this function to include that in every prompt.
# Cut-out on the sleeve, ruffles on the necline and stuff like that
common_atr = ['colour', 'aesthetic', 'fabric', 'style']
bottoms = ['skirt', 'trousers', 'shorts', 'knicker']
sleeves = ["off-shoulder", "sleeveless", "strap", "strapless"]


def create_clothing_prompts(descriptions, clothing_type, featured=""):
    # intro = random.choice(r.poetic_intros)
    # ending = random.choice(r.poetic_endings)
    enh = random.sample(r.enhancements, 2)
    background_choice = random.choice(r.background)
    prompt = "A stylish and sophisticated"
    # Add common attributes
    for attr in common_atr:
        if attr in descriptions:
            prompt += f" {descriptions[attr]}"
    # Add sleeve details for tops/dresses
    if 'sleeve' in descriptions and descriptions['sleeve'] in sleeves:
        prompt += f" {descriptions['sleeve']}"
    if featured:
        if "," in featured:
            parts = featured.split(",", 1)
            featured = f"{parts[0]} {clothing_type},{parts[1]}"
        else:
            featured = f'{clothing_type}, with {featured}'
        prompt += f" {featured}, worn by a  {descriptions.get('woman')} woman,"
    else:
        prompt += f" {clothing_type}, worn by a  {descriptions.get('woman')} woman,"
    # Add pattern
    if 'pattern' in descriptions:
        prompt += f" showcasing a {descriptions['pattern']} print pattern,"
    # Add themes
    if 'theme' in descriptions:
        prompt += f" {descriptions['theme']} themed,"
    if 'occasion' in descriptions:
        prompt += f"  perfect for {descriptions['occasion']},"
    # Add details based on clothing type
    if 'waistline' in descriptions:
        prompt += f" {descriptions['waistline']} waisted,"
    if 'neckline' in descriptions:
        prompt += f" with a {descriptions['neckline']} neckline,"
    if 'fit' in descriptions:
        prompt += f"  cut in a {descriptions['fit']} silhouette,"
    if 'closure' in descriptions:
        prompt += f"  finished with {descriptions['closure']} closure,"
    # Add sleeve details for non-special sleeve types
    if 'sleeve' in descriptions and descriptions['sleeve'] not in sleeves:
        prompt += f"  detailed with  {descriptions['sleeve']} sleeves,"
    if 'embellishments' in descriptions:
        prompt += f" {clothing_type} is elegantly adorned with {descriptions['embellishments']}."
    # Select two random unique enhancements
    prompt += f" Infused with {enh[0]} and {enh[1]}."
    # Add final quality specifications
    prompt += f" Background of a {background_choice},"
    prompt += " highly detailed, professional photography, product showcase. \n"
    return prompt

# first argument removed
def featured(n_design, part, others=''):
    if n_design < 1 or n_design > len(part):
        mssg = "Invalid value for n_design. \
        It should be between 1 and the length of the PARTS list."
        raise ValueError()

    words_aesthetic = random.sample(r.aesthetic, n_design)
    words_design = random.sample(r.aestheticDesign, n_design)
    words_part = random.choice(part)

    paired_phrases = [f"{aesthetic} {design} design " for aesthetic, design in zip(words_aesthetic, words_design)]

    # Join them into a single string
    joined_phrases = ", ".join(paired_phrases)

    description = f"{joined_phrases} on the {words_part}"
    if others:
        return f"{others}, with {description}"
    else:
        return description


def selectFeatures(attr_dic, num_attr, num_output,features={}):
    # Create a list of keys for random selection
    keys = list(attr_dic.keys())

    result = []
    for _ in range(num_output):
        # Randomly pick n1 keys
        selected_keys = random.sample(keys, num_attr)

        # Ensure that "body_shape" is one of the selected keys
        if "woman" not in selected_keys:
            selected_keys.append("woman")
        # Ensure that "colour" is one of the selected keys
        # remove if this function will be used for colour combination outfits
        if "occasion" not in selected_keys:
            selected_keys.append("occasion")

        # Randomly pick one element from each list of the selected keys
        selected_values = {
            key: random.choice(attr_dic[key]) for key in selected_keys
        }
        selected_values.update(features)

        # Add the selected values to the result list
        result.append(selected_values)

    return result


def createOutfitPrompts(top, skirt, up, down):
    prompt = "A woman wearing a (sophisticated 1.6)"

    sleeves = ["off-shoulder", "sleeveless", "strap", "strapless"]

    if 'cp' in top:
        prompt += f" {top['cp']}," # palette,

    if 'length' in top:
        prompt += f" {top['length']}"

    if 'fabric' in top:
        prompt += f" {top['fabric']}"

    if "sleeve" in top and top['sleeve'] in sleeves:
        prompt += f" {top['sleeve']}"

    if 'occasion' in top:
        prompt += f" {top['occasion']}"

    if 'style' in top:
        prompt += f" {top['style']}"

    prompt += f" {up},"

    if 'themes' in top:
        prompt += f" with a {top['themes']} theme,"

    if 'aesthetic' in top:
        prompt += f" aiming for an {top['aesthetic']} look,"

    if 'neckline' in top:
        prompt += f" featuring a {top['neckline']} neckline,"

    if 'fit' in top:
        prompt += f" with a {top['fit']} fit,"

    if 'closure' in top:
        prompt += f" with {top['closure']} closure,"

    if 'sleeve' in top and top['sleeve'] not in sleeves:
        prompt += f" with {top['sleeve']} sleeves,"

    if 'embellishment' in top:
        prompt += f" adorned with {top['embellishments']},"

    prompt += f" and a"
    if 'cp' in skirt:
        prompt += f" {skirt['cp']}," # palette,

    if 'length' in skirt:
        prompt += f" {skirt['length']}"

    if 'fabric' in skirt:
        prompt += f" {skirt['fabric']}"

    if 'occasion' in skirt:
        prompt += f" {skirt['occasion']}"

    if 'style' in skirt:
        prompt += f" {skirt['style']}"

    prompt += f" {down},"

    if 'themes' in skirt:
        prompt += f" with a {skirt['themes']} theme,"

    if 'aesthetic' in skirt:
        prompt += f" aiming for an {top['aesthetic']} look,"

    if 'neckline' in skirt:
        prompt += f" featuring a {skirt['neckline']} neckline,"

    if 'fit' in skirt:
        prompt += f" with a {skirt['fit']} fit,"

    if 'closure' in skirt:
        prompt += f" with {skirt['closure']} closure,"

    if 'embellishment' in skirt:
        prompt += f" adorned with {skirt['embellishments']},"

    prompt += " outfit is stylish and fashionable \n\n" #(high fashion 1.2).\n\n"

    return prompt

def create_clothing_prompts2(descriptions, clothing_type, featured=""):
    if "," not in featured:
        featured = f'{clothing_type}, with {featured}'
    prompt = 'image of a stylish'
    # Add common attributes
    for attr in common_atr:
        if attr in descriptions:
            prompt += f" {descriptions[attr]}"
    # Add sleeve details for tops/dresses
    if 'sleeve' in descriptions and descriptions['sleeve'] in sleeves:
        prompt += f" {descriptions['sleeve']}"
    # Initialize prompt with woman description
    if featured:
            prompt += f" {featured}, worn by a  {descriptions.get('woman')} woman,"
    else:
        prompt += f" {clothing_type}, worn by a  {descriptions.get('woman')} woman,"
    # Add pattern
    if 'pattern' in descriptions:
        prompt += f" {descriptions['pattern']} print pattern,"
    # Add themes
    if 'themes' in descriptions:
        prompt += f" {descriptions['themes']} themed,"
    if 'occasion' in descriptions:
        prompt += f" perfect for {descriptions['occasion']},"
    # Add details based on clothing type
    if 'waistline' in descriptions:
        prompt += f" {descriptions['waistline']} waisted,"
    if 'neckline' in descriptions:
        prompt += f" with a {descriptions['neckline']} neckline,"
    if 'fit' in descriptions:
        prompt += f"  cut in a {descriptions['fit']} silhouette,"
    if 'closure' in descriptions:
        prompt += f" {descriptions['closure']} closure,"
    # Add sleeve details for non-special sleeve types
    if 'sleeve' in descriptions and descriptions['sleeve'] not in sleeves:
        prompt += f"  {descriptions['sleeve']} sleeves,"
    if 'embellishments' in descriptions:
        prompt += f" adorned with {descriptions['embellishments']}."
    # Add background
    prompt += f" background of {random.choice(r.background)},"
    prompt += f" {clothing_type} is stylish and sophisticated. \n"

    return prompt