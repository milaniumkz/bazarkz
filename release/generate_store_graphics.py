"""Render editable vector artwork for the two Google Play listings."""
from pathlib import Path
import shutil
import cairosvg

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / 'release/store-assets'
OUT.mkdir(exist_ok=True)

for kind, project, kicker, lines, footer in [
    ('buyer', 'bazar_kz', 'ПОКУПАТЕЛЯМ',
     ('Магазины и товары', 'вашего города'), 'Каталог · Избранное · Заказы'),
    ('seller', 'bazarkz_seller', 'ДЛЯ ПРОДАВЦОВ',
     ('Ваш магазин.', 'Всегда под рукой.'), 'Магазины · Товары · Заказы'),
]:
    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="500" viewBox="0 0 1024 500">
<rect width="1024" height="500" fill="#FFF8F1"/>
<circle cx="925" cy="249" r="254" fill="#F0E4DA"/>
<circle cx="998" cy="28" r="105" fill="#E5C4B2"/>
<text x="64" y="79" font-family="Arial,sans-serif" font-size="32" font-weight="700" fill="#29252B">BazarKz</text>
<text x="65" y="150" font-family="Arial,sans-serif" font-size="14" font-weight="700" letter-spacing="2.2" fill="#9B3E33">{kicker}</text>
<text x="61" y="223" font-family="Arial,sans-serif" font-size="49" font-weight="700" fill="#29252B">{lines[0]}</text>
<text x="61" y="285" font-family="Arial,sans-serif" font-size="49" font-weight="700" fill="#29252B">{lines[1]}</text>
<rect x="64" y="326" width="58" height="5" rx="2.5" fill="#B84B3E"/>
<text x="64" y="390" font-family="Arial,sans-serif" font-size="20" fill="#62595A">{footer}</text>
<rect x="739" y="185" width="199" height="184" rx="28" fill="#D4B6A5"/>
<rect x="728" y="174" width="199" height="184" rx="28" fill="#B84B3E"/>
<path d="M778 190v-30a49 49 0 0 1 98 0v30" fill="none" stroke="#FFF8F1" stroke-width="14" stroke-linecap="round"/>
<circle cx="777" cy="205" r="9" fill="#FFF8F1"/>
<circle cx="876" cy="205" r="9" fill="#FFF8F1"/>
<path d="m797 277 22 22 43-48" fill="none" stroke="#FFF8F1" stroke-width="12" stroke-linecap="round" stroke-linejoin="round"/>
</svg>'''
    (OUT / f'{kind}-feature.svg').write_text(svg)
    cairosvg.svg2png(bytestring=svg.encode(), write_to=str(OUT / f'{kind}-feature.png'))
    shutil.copy2(ROOT / project / 'web/icons/Icon-512.png', OUT / f'{kind}-icon-512.png')
    print(f'{kind}: feature graphic 1024×500 and existing brand icon 512×512')
