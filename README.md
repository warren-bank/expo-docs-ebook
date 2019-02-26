### [Ebook conversion scripts: Expo SDK Documentation](https://github.com/warren-bank/expo-docs-ebook)

Scripts to download and convert the official _Expo SDK Documentation_ into ebook formats.

#### Official Documentation

* [HTML on the web](https://docs.expo.io/)
* [Markdown on GitHub](https://github.com/expo/expo/tree/master/docs)

#### Installation (npm):

```bash
mkdir 'workspace'
cd    'workspace'

npm init -y
npm install --save  "@warren-bank/expo-docs-ebook"
mv     'node_modules/@warren-bank/expo-docs-ebook' .
rm -rf 'node_modules'
rm -f  package*

cd 'expo-docs-ebook'
npm install
```

#### Installation (github):

```bash
mkdir 'workspace'
cd    'workspace'

wget --content-disposition --no-check-certificate 'https://github.com/warren-bank/expo-docs-ebook/archive/master.zip'
unzip 'expo-docs-ebook-master.zip'
rm -f 'expo-docs-ebook-master.zip'

cd 'expo-docs-ebook-master'
npm install
```

#### Installation notes:

* [calibre](https://github.com/kovidgoyal/calibre/releases) is installed automatically on Windows as a portable executable in: `dep/`
  * other platforms must ensure that the `ebook-convert` binary can be found in: `$PATH`
* [GitBook](https://github.com/GitbookIO/gitbook) is not installed when the default global installation directory exists: `$HOME/.gitbook`

#### Usage:

```bash
# to generate all ebook formats: pdf, epub, mobi
npm run "gitbook:all"

# to generate one specific ebook format: pdf
npm run "gitbook:pdf"

# to generate one specific ebook format: epub
npm run "gitbook:epub"

# to generate one specific ebook format: mobi
npm run "gitbook:mobi"

# to cleanup all intermediate work product
# (is run automatically before each build)
npm run "gitbook:clean"
```

* all ebooks are saved to: `dist/`

#### Configuration:

* file:<br>`.scripts/env.sh`
  ```bash
    export ebook_version='v32.0.0'
    export ebook_commit='master'
  ```
  * specifies that markdown files should be obtained from:<br>[https://github.com/expo/expo/tree/master/docs/pages/versions/v32.0.0](https://github.com/expo/expo/tree/master/docs/pages/versions/v32.0.0)
* file:<br>`.scripts/assets/cover.jpg`
  * contains the SDK version number
  * by opening the following file in GIMP:<br>`.scripts/.etc/cover-image/2-cover.xcf`
    * this text can be edited
    * an updated JPG can be exported

#### Legal:

* copyright: [Warren Bank](https://github.com/warren-bank)
* license: [GPL-2.0](https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt)
