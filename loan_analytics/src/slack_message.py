import json
import requests
from datetime import datetime

def build_message(alert_name, metrics):
    
    detail = [ f"- {k} \n" for k in metrics]
    
    return {
      "channel": "#analytics_challenge",
      "attachments": [
          {
              "fallback": "Plain-text summary of the attachment.",
              "color": "#00FF00",
              "pretext": f":green: {alert_name}",
              "author_name": "",
              "author_link": "",
              "author_icon": "",
              "title": "Analytics Dashboard",
              "title_link": "",
              "text": " ".join(detail),
              "fields": [
                  {
                      "title": "Priority",
                      "value": "High",
                      "short": False
                  }
              ],
              "image_url": "",
              "thumb_url": "",
              "footer": "",
              "footer_icon": "",
              "ts": datetime.now().timestamp()
          },
          {
        	"blocks": [
        		{
        			"type": "section",
        			"text": {
        				"type": "mrkdwn",
        				"text": "See Dashboard."
        			},
        			"accessory": {
        				"type": "button",
        				"text": {
        					"type": "plain_text",
        					"text": "Details",
        					"emoji": True
        				},
        				"value": "click_me_123",
        				"url": "http://localhost:3000/dashboard/1-loans-and-installments-dashboard?tab=1-tab-1",
        				"action_id": "button-action"
        			}
        		}
        	]
         }
      ]
    }

def send_message(alert_name, metrics):
    webhook_url = "https://hooks.slack.com/services/xxx/xxx/xxx"
    try:
        message = json.dumps(build_message(alert_name, metrics))
        print(message)
        r = requests.post(webhook_url, message)
        print(r)
        print("Messge posted to Slack")
    except Exception as e:
        print(f"Request failed: {e}")
