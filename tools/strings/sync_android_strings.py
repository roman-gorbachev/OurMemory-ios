"""Sync Localizable.xcstrings with the Android string resources.

    python3 tools/strings/sync_android_strings.py OurMemory/Resources/Localizable.xcstrings [path/to/android/app/src/main/res]

Android values/ (Russian) and values-be/, values-en/, values-zh/ are the source of truth for shared keys.
Keys that exist only in the catalog (iOS-only strings) are kept as they are.
"""
import xml.etree.ElementTree as ET, json, os, re, sys
RES=sys.argv[2] if len(sys.argv) > 2 else os.path.expanduser('~/Personal/OurMemory-80/app/src/main/res')
def unesc(s):
    if s is None: return ''
    s=s.strip()
    if len(s)>=2 and s[0]=='"' and s[-1]=='"': s=s[1:-1]
    else: s=re.sub(r'\s+',' ',s)
    s=s.replace("\\'", "'").replace('\\"','"').replace('\\n','\n').replace('\\t','\t').replace('\\@','@').replace('\\?','?')
    s=re.sub(r'%(\d+\$)?s', lambda m: '%'+(m.group(1) or '')+'@', s)
    s=re.sub(r'%(\d+\$)?d', lambda m: '%'+(m.group(1) or '')+'lld', s)
    return s
def text(el):
    return ''.join(el.itertext())
def load(lang):
    root=ET.parse(f'{RES}/values{"-"+lang if lang else ""}/strings.xml').getroot()
    out={}
    for el in root:
        n=el.get('name')
        if el.tag=='string': out[n]=('s',unesc(text(el)))
        elif el.tag=='plurals': out[n]=('p',{i.get('quantity'):unesc(text(i)) for i in el})
        elif el.tag=='string-array': out[n]=('s','\n'.join(unesc(text(i)) for i in el))
    return out
TRANSLATIONS=[('be','be'),('en','en'),('zh','zh-Hans')]
ru=load(''); translated={locale: load(folder) for folder,locale in TRANSLATIONS}
cat={"sourceLanguage":"ru","version":"1.0","strings":{}}
def unit(v): return {"stringUnit":{"state":"translated","value":v}}
def loc(kind,val):
    if kind=='s': return unit(val)
    return {"variations":{"plural":{q:unit(v) for q,v in val.items()}}}
for k,(kind,val) in ru.items():
    e={"extractionState":"manual","localizations":{"ru":loc(kind,val)}}
    for locale,values in translated.items():
        if k in values: e["localizations"][locale]=loc(*values[k])
    if not any(k in values for values in translated.values()): e["shouldTranslate"]=False
    cat["strings"][k]=e
if os.path.exists(sys.argv[1]):
    existing=json.load(open(sys.argv[1]))['strings']
    for k,v in existing.items():
        if k not in cat['strings']: cat['strings'][k]=v
json.dump(cat, open(sys.argv[1],'w'), ensure_ascii=False, indent=2, sort_keys=True)
print(len(cat["strings"]), 'keys; missing:', {locale: [k for k in ru if k not in values] for locale,values in translated.items()})
print('plurals:', [k for k,(t,_) in ru.items() if t=='p'])
