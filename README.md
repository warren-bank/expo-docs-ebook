### [Ebook conversion scripts: Expo SDK Documentation](https://github.com/warren-bank/expo-docs-ebook)

Scripts to download and convert the official _Expo SDK Documentation_ into ebook formats.

#### Official Documentation

* [HTML on the web](https://docs.expo.io/)
* [Markdown on GitHub](https://github.com/expo/expo/tree/master/docs)

#### Installation:

```bash
mkdir 'expo-docs-ebook'
cd    'expo-docs-ebook'

npm init -y
npm install --save "@warren-bank/expo-docs-ebook"
```

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
