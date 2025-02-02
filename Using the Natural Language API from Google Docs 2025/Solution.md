# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

#### ⚠️ Disclaimer :
- **This script is for the educational purposes just to show how quickly we can solve lab. Please make sure that you have a thorough understanding of the instructions before utilizing any scripts. We do not promote cheating or  misuse of resources. Our objective is to assist you in mastering the labs with efficiency, while also adhering to both 'qwiklabs' terms of services and YouTube's community guidelines.**

## Run in CloudShell and follow video:

- Open Link 1: https://console.cloud.google.com/marketplace/product/google/language.googleapis.com?q
- Open Api : https://console.cloud.google.com/apis/credentials
- Open doc and paste below code: https://docs.google.com/document/create

```

/**
* @OnlyCurrentDoc
*
* The above comment directs Apps Script to limit the scope of file
* access for this add-on. It specifies that this add-on will only
* attempt to read or modify the files in which the add-on is used,
* and not all of the user's files. The authorization request message
* presented to users will reflect this limited scope.
*/
/**
* Creates a menu entry in the Google Docs UI when the document is
* opened.
*
*/
function onOpen() {
  var ui = DocumentApp.getUi();
  ui.createMenu('Natural Language Tools')
    .addItem('Mark Sentiment', 'markSentiment')
    .addToUi();
}
/**
* Gets the user-selected text and highlights it based on sentiment
* with green for positive sentiment, red for negative, and yellow
* for neutral.
*
*/
function markSentiment() {
  var POSITIVE_COLOR = '#00ff00';  //  Colors for sentiments
  var NEGATIVE_COLOR = '#ff0000';
  var NEUTRAL_COLOR = '#ffff00';
  var NEGATIVE_CUTOFF = -0.2;   //  Thresholds for sentiments
  var POSITIVE_CUTOFF = 0.2;
  var selection = DocumentApp.getActiveDocument().getSelection();
  if (selection) {
    var string = getSelectedText();
    var sentiment = retrieveSentiment(string);
    //  Select the appropriate color
    var color = NEUTRAL_COLOR;
    if (sentiment <= NEGATIVE_CUTOFF) {
      color = NEGATIVE_COLOR;
    }
    if (sentiment >= POSITIVE_CUTOFF) {
      color = POSITIVE_COLOR;
    }
    //  Highlight the text
    var elements = selection.getSelectedElements();
    for (var i = 0; i < elements.length; i++) {
      if (elements[i].isPartial()) {
        var element = elements[i].getElement().editAsText();
        var startIndex = elements[i].getStartOffset();
        var endIndex = elements[i].getEndOffsetInclusive();
        element.setBackgroundColor(startIndex, endIndex, color);
      } else {
        var element = elements[i].getElement().editAsText();
        foundText = elements[i].getElement().editAsText();
        foundText.setBackgroundColor(color);
      }
    }
  }
}
/**
 * Returns a string with the contents of the selected text.
 * If no text is selected, returns an empty string.
 */
function getSelectedText() {
  var selection = DocumentApp.getActiveDocument().getSelection();
  var string = "";
  if (selection) {
    var elements = selection.getSelectedElements();
    for (var i = 0; i < elements.length; i++) {
      if (elements[i].isPartial()) {
        var element = elements[i].getElement().asText();
        var startIndex = elements[i].getStartOffset();
        var endIndex = elements[i].getEndOffsetInclusive() + 1;
        var text = element.getText().substring(startIndex, endIndex);
        string = string + text;
      } else {
        var element = elements[i].getElement();
        // Only translate elements that can be edited as text; skip
        // images and other non-text elements.
        if (element.editAsText) {
          string = string + element.asText().getText();
        }
      }
    }
  }
  return string;
}
/** Given a string, will call the Natural Language API and retrieve
  * the sentiment of the string.  The sentiment will be a real
  * number in the range -1 to 1, where -1 is highly negative
  * sentiment and 1 is highly positive.
*/
function retrieveSentiment (line) {
//  TODO:  Call the Natural Language API with the line given
//         and return the sentiment value.
  return 0.0;
}



```

## ©Credit :
- All rights and credits goes to original content of Google Cloud [Google Cloud SkillBoost](https://www.cloudskillsboost.google/) 

## Congratulations !!

### ** Join us on below platforms **

- <img width="25" alt="image" src="https://github.com/user-attachments/assets/171448df-7b22-4166-8d8d-86f72fb78aff"> [Telegram Discussion Group](https://t.me/+HiOSF3PxrvFhNzU1)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/0ebd7e7d-6f9b-41e9-a241-8483dca9f3f1"> [Telegram Channel](https://t.me/abhiarcadesolution)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/dc326965-d4fa-4f1b-87f1-dbad6e3a7259"> [Abhi Arcade Solution](https://www.youtube.com/@Abhi_Arcade_Solution)
- <img width="26" alt="image" src="https://github.com/user-attachments/assets/d9070a07-7fce-47c5-8626-7ea98ccc46e3"> [WhatsApp](https://whatsapp.com/channel/0029VakEGSJ0VycJcnB8Fn3z)
- <img width="23" alt="image" src="https://github.com/user-attachments/assets/ce0916c3-e5f9-4709-afbd-e67bd42d1c57"> [LinkedIn](https://www.linkedin.com/in/abhi-arcade-solution-9b8a15319/)
