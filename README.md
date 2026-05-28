# charcount - lite-xl plugin
lite-xl plugin to display character and newline counts of a document and selections.


## Quick installation
- Download or clone the repository and copy the file `charcount.lua` to the lite-xl plugin folder to: `lite-xl/plugins/`.
 
In case of questions, refer to the ["lite-xl plugin installation guide"](https://github.com/lite-xl/lite-xl-plugins).


## Usage
The plugin should work out-of-box after copying the file `charcount.lua` to the plugin directory.

If everything is setup, you should see the following informations  in the status bar of lite-xl:

`XX characters ( + new lines: XX )`

### What is counted?
- `characters` - everything what is not a new line character, in this case `\n`
- `new lines` - are displayed separately.

---


## Example screenshots

### No selection - Displays the count of all characters and newlines of the current document
<img width="1053" height="452" alt="document information" src="https://github.com/user-attachments/assets/935d4bd6-edc2-4594-ac6a-1ba0bd5281b1" />

---

### Single selection - Displays characters of the current selection
<img width="1053" height="452" alt="singe selection" src="https://github.com/user-attachments/assets/6327a999-8e64-4128-b2ae-679e88db58f1" />

---

### Multiple selections - Display characters of all selections
<img width="1053" height="452" alt="ranged selections" src="https://github.com/user-attachments/assets/c04d1094-2257-4b21-9f1d-b75b7678f238" />

---

### Ranged selection, here with newlines too
<img width="1053" height="452" alt="multiple selections" src="https://github.com/user-attachments/assets/5f87ecb0-acf9-40c4-9136-e983a47e3fd9" />

---

### Only newlines are also displayed
<img width="1053" height="452" alt="only newlines" src="https://github.com/user-attachments/assets/a8fd93e9-3599-4135-a619-f8b1852dcda0" />
