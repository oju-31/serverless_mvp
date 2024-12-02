import os
import raw_data as r
import random

# because the designs were better when there certain design enhacer like
# cut-outs, I added this function to include that in every prompts.
# Cut-out on the sleeve, ruffles on the necline and stuff like that
def featured(n_aesthetic, n_design, part, others=""):
    if n_aesthetic < 0 or n_aesthetic > len(r.aesthetic):
        mssg = "Invalid value for n_aesthetic.\
        It should be between 0 and the length of the aesthetic list."
        raise ValueError(mssg)

    if n_design < 1 or n_design > len(r.aestheticDesign):
        mssg = "Invalid value for n_design. \
        It should be between 1 and the length of the aesthetic_design list."
        raise ValueError()

    words_aesthetic = random.sample(r.aesthetic, n_aesthetic)
    words_design = random.sample(r.aestheticDesign, n_design)
    words_part = random.choice(r.part)

    if len(words_aesthetic) > 1:
        joined_aesthetic = " and ".join(words_aesthetic)
    else:
        joined_aesthetic = words_aesthetic[0]

    if len(words_design) > 1:
        joined_design = " and ".join(words_design)
    else:
        joined_design = words_design[0]

    description = f"{joined_aesthetic} {joined_design} design on the {words_part}"
    if others:
        return f"{others}, {description}"
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


def create_clothing_prompts(descriptions, clothing_type, featured=""):
    sleeves = ["off-shoulder", "sleeveless", "strap", "strapless"]
    
    # Initialize prompt with woman description
    if 'woman' in descriptions:
        prompt = f"{featured}, a {descriptions['woman']} woman wearing a"
    else:
        prompt = f"{featured}, a woman wearing a"

    # Add color
    if 'colour' in descriptions:
        prompt += f" {descriptions['colour']}"
        if clothing_type not in ['skirt', 'trousers']:
            prompt += ","

    # Add pattern for skirts and trousers
    if 'pattern' in descriptions and clothing_type in ['skirt', 'trousers']:
        prompt += f" {descriptions['pattern']} print"

    # Add sleeve details for tops/dresses
    if clothing_type in ['dress', 'top', 'blouse'] and 'sleeve' in descriptions and descriptions['sleeve'] in sleeves:
        prompt += f" {descriptions['sleeve']}"

    # Add common attributes
    for attr in ['length', 'fabric', 'occasion', 'style']:
        if attr in descriptions:
            prompt += f" {descriptions[attr]}"

    # Add clothing type
    prompt += f" {clothing_type},"

    # Add themes
    if 'themes' in descriptions:
        prompt += f" {descriptions['themes']} theme,"

    # Add details based on clothing type
    if clothing_type in ['skirt', 'trousers'] and 'waistline' in descriptions:
        prompt += f" {descriptions['waistline']} waisted,"

    if 'neckline' in descriptions and clothing_type not in ['skirt', 'trousers']:
        prompt += f" {descriptions['neckline']} neckline,"

    if 'fit' in descriptions:
        prompt += f" {descriptions['fit']} fit,"

    if 'closure' in descriptions:
        prompt += f" {descriptions['closure']} closure,"

    # Add sleeve details for non-special sleeve types
    if clothing_type in ['dress', 'top', 'blouse'] and 'sleeve' in descriptions and descriptions['sleeve'] not in sleeves:
        prompt += f" {descriptions['sleeve']} sleeves,"

    if 'embellishments' in descriptions:
        prompt += f" {descriptions['embellishments']},"

    prompt += f" high fashion, haute couture, lifelike \n\n"

    return prompt