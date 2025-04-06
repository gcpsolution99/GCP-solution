# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

#### ⚠️ Disclaimer :
- **This script is for the educational purposes just to show how quickly we can solve lab. Please make sure that you have a thorough understanding of the instructions before utilizing any scripts. We do not promote cheating or  misuse of resources. Our objective is to assist you in mastering the labs with efficiency, while also adhering to both 'qwiklabs' terms of services and YouTube's community guidelines.**

## Task 1:  Open appscript: [Google Apps Script](https://script.google.com/home/projects/create?template=hangoutsChat) and Paste below code

    /**
     * Responds to a MESSAGE event in Google Chat.
     *
     * @param {Object} event the event object from Google Chat
     */
    function onMessage(event) {
      var name = "";

      if (event.space.type == "DM") {
        name = "You";
      } else {
        name = event.user.displayName;
      }
      var message = name + " said \"" + event.message.text + "\"";

      return { "text": message };
    }

    /**
     * Responds to an ADDED_TO_SPACE event in Google Chat.
     *
     * @param {Object} event the event object from Google Chat
     */
    function onAddToSpace(event) {
      var message = "";

      if (event.space.singleUserBotDm) {
        message = "Thank you for adding me to a DM, " + event.user.displayName + "!";
      } else {
        message = "Thank you for adding me to " +
            (event.space.displayName ? event.space.displayName : "this chat");
      }

      if (event.message) {
        // Bot added through @mention.
        message = message + " and you said: \"" + event.message.text + "\"";
      }
      console.log('Attendance Bot added in ', event.space.name);
      return { "text": message };
    }

    /**
     * Responds to a REMOVED_FROM_SPACE event in Google Chat.
     *
     * @param {Object} event the event object from Google Chat
     */
    function onRemoveFromSpace(event) {
      console.info("Bot removed from ",
          (event.space.name ? event.space.name : "this chat"));
    }
    

## Task 2: Follow video

## Task 3: Copy and paste below code in code.gs

    var DEFAULT_IMAGE_URL = 'https://goo.gl/bMqzYS';
    var HEADER = {
      header: {
        title : 'Attendance Bot',
        subtitle : 'Log your vacation time',
        imageUrl : DEFAULT_IMAGE_URL
      }
    };

    /**
     * Creates a card-formatted response.
     * @param {object} widgets the UI components to send
     * @return {object} JSON-formatted response
     */
    function createCardResponse(widgets) {
      return {
        cards: [HEADER, {
          sections: [{
            widgets: widgets
          }]
        }]
      };
    }

    /**
     * Responds to a MESSAGE event triggered
     * in Google Chat.
     *
     * @param event the event object from Google Chat
     * @return JSON-formatted response
     */
    function onMessage(event) {
      var userMessage = event.message.text;

      var widgets = [{
        "textParagraph": {
          "text": "You said: " + userMessage
        }
      }];

      console.log('You said:', userMessage);

      return createCardResponse(widgets);
    }

    /**
     * Responds to an ADDED_TO_SPACE event in Google Chat.
     *
     * @param {Object} event the event object from Google Chat
     */
    function onAddToSpace(event) {
      var message = "";

      if (event.space.singleUserBotDm) {
        message = "Thank you for adding me to a DM, " + event.user.displayName + "!";
      } else {
        message = "Thank you for adding me to " +
            (event.space.displayName ? event.space.displayName : "this chat");
      }

      if (event.message) {
        // Bot added through @mention.
        message = message + " and you said: \"" + event.message.text + "\"";
      }
      console.log('Attendance Bot added in ', event.space.name);
      return { "text": message };
    }

    /**
     * Responds to a REMOVED_FROM_SPACE event in Google Chat.
     *
     * @param {Object} event the event object from Google Chat
     */
    function onRemoveFromSpace(event) {
      console.info("Bot removed from ",
          (event.space.name ? event.space.name : "this chat"));
    }
---

## Task 4: Copy and paste below code in code.gs

    var DEFAULT_IMAGE_URL = 'https://goo.gl/bMqzYS';
    var HEADER = {
      header: {
        title : 'Attendance Bot',
        subtitle : 'Log your vacation time',
        imageUrl : DEFAULT_IMAGE_URL
      }
    };

    /**
     * Creates a card-formatted response.
     * @param {object} widgets the UI components to send
     * @return {object} JSON-formatted response
     */
    function createCardResponse(widgets) {
      return {
        cards: [HEADER, {
          sections: [{
            widgets: widgets
          }]
        }]
      };
    }

    var REASON = {
      SICK: 'Out sick',
      OTHER: 'Out of office'
    };
    /**
     * Responds to a MESSAGE event triggered in Google Chat.
     * @param {object} event the event object from Google Chat
     * @return {object} JSON-formatted response
     */
    function onMessage(event) {
      console.info(event);
      var reason = REASON.OTHER;
      var name = event.user.displayName;
      var userMessage = event.message.text;

      // If the user said that they were 'sick', adjust the image in the
      // header sent in response.
      if (userMessage.toLowerCase().indexOf('sick') > -1) {
        // Hospital material icon
        HEADER.header.imageUrl = 'https://goo.gl/mnZ37b';
        reason = REASON.SICK;
      } else if (userMessage.toLowerCase().indexOf('vacation') > -1) {
        // Spa material icon
        HEADER.header.imageUrl = 'https://goo.gl/EbgHuc';
      } else {
         // Reset to default image if keywords not found
         HEADER.header.imageUrl = DEFAULT_IMAGE_URL;
      }


      var widgets = [{
        textParagraph: {
          text: 'Hello, ' + name + '.<br>Are you taking time off today?'
        }
      }, {
        buttons: [{
          textButton: {
            text: 'Set vacation in Gmail',
            onClick: {
              action: {
                actionMethodName: 'turnOnAutoResponder',
                parameters: [{
                  key: 'reason',
                  value: reason
                }]
              }
            }
          }
        }, {
          textButton: {
            text: 'Block out day in Calendar',
            onClick: {
              action: {
                actionMethodName: 'blockOutCalendar',
                parameters: [{
                  key: 'reason',
                  value: reason
                }]
              }
            }
          }
        }]
      }];
      return createCardResponse(widgets);
    }

    /**
     * Responds to an ADDED_TO_SPACE event in Google Chat.
     *
     * @param {Object} event the event object from Google Chat
     */
    function onAddToSpace(event) {
      var message = "";

      if (event.space.singleUserBotDm) {
        message = "Thank you for adding me to a DM, " + event.user.displayName + "!";
      } else {
        message = "Thank you for adding me to " +
            (event.space.displayName ? event.space.displayName : "this chat");
      }

      if (event.message) {
        // Bot added through @mention.
        message = message + " and you said: \"" + event.message.text + "\"";
      }
      console.log('Attendance Bot added in ', event.space.name);
      return { "text": message };
    }

    /**
     * Responds to a REMOVED_FROM_SPACE event in Google Chat.
     *
     * @param {Object} event the event object from Google Chat
     */
    function onRemoveFromSpace(event) {
      console.info("Bot removed from ",
          (event.space.name ? event.space.name : "this chat"));
    }

    /**
     * Responds to a CARD_CLICKED event triggered in Google Chat.
     * @param {object} event the event object from Google Chat
     * @return {object} JSON-formatted response
     * @see https://developers.google.com/chat/reference/message-formats/events
     */
    function onCardClick(event) {
      console.info(event);
      var message = '';
      var reason = event.action.parameters[0].value;
      if (event.action.actionMethodName == 'turnOnAutoResponder') {
        turnOnAutoResponder(reason);
        message = 'Turned on vacation settings in Gmail.';
      } else if (event.action.actionMethodName == 'blockOutCalendar') {
        blockOutCalendar(reason);
        message = 'Blocked out your calendar for the day.';
      } else {
        message = "I'm sorry; I'm not sure which button you clicked.";
      }
      return { text: message };
    }

    var ONE_DAY_MILLIS = 24 * 60 * 60 * 1000;
    /**
     * Turns on the user's vacation response for today in Gmail.
     * Requires the Gmail API advanced service.
     * @param {string} reason the reason for vacation, either REASON.SICK or REASON.OTHER
     */
    function turnOnAutoResponder(reason) {
      var currentTime = (new Date()).getTime();
      // Ensure Gmail API service is enabled in Apps Script
      try {
        Gmail.Users.Settings.updateVacation({
          enableAutoReply: true,
          responseSubject: reason,
          responseBodyHtml: "I'm out of the office today; will be back on the next business day.<br><br><i>Created by Attendance Bot!</i>",
          restrictToContacts: true,
          restrictToDomain: true,
          startTime: currentTime,
          endTime: currentTime + ONE_DAY_MILLIS
        }, 'me');
         console.log('Gmail vacation responder activated for:', reason);
      } catch (e) {
        console.error('Error activating Gmail vacation responder:', e);
        // Potentially return an error message to the user via Chat?
      }
    }

    /**
     * Places an all-day event on the user's primary Calendar.
     * Uses the default CalendarApp service.
     * @param {string} reason the reason for vacation, either REASON.SICK or REASON.OTHER
     */
    function blockOutCalendar(reason) {
       try {
        CalendarApp.createAllDayEvent(reason, new Date(), new Date(Date.now() + ONE_DAY_MILLIS));
        console.log('Calendar blocked out for:', reason);
      } catch (e) {
        console.error('Error blocking out calendar:', e);
         // Potentially return an error message to the user via Chat?
      }
    }


## ©Credit :
- All rights and credits goes to original content of Google Cloud [Google Cloud SkillBoost](https://www.cloudskillsboost.google/) 

## Congratulations !!

### ** Join us on below platforms **

- <img width="25" alt="image" src="https://github.com/user-attachments/assets/171448df-7b22-4166-8d8d-86f72fb78aff"> [Telegram Discussion Group](https://t.me/+HiOSF3PxrvFhNzU1)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/0ebd7e7d-6f9b-41e9-a241-8483dca9f3f1"> [Telegram Channel](https://t.me/abhiarcadesolution)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/dc326965-d4fa-4f1b-87f1-dbad6e3a7259"> [Abhi Arcade Solution](https://www.youtube.com/@Abhi_Arcade_Solution)
- <img width="26" alt="image" src="https://github.com/user-attachments/assets/d9070a07-7fce-47c5-8626-7ea98ccc46e3"> [WhatsApp](https://whatsapp.com/channel/0029VakEGSJ0VycJcnB8Fn3z)
- <img width="23" alt="image" src="https://github.com/user-attachments/assets/ce0916c3-e5f9-4709-afbd-e67bd42d1c57"> [LinkedIn](https://www.linkedin.com/in/abhi-arcade-solution-9b8a15319/)
