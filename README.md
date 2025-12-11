##  Setup

### 1. Unzip the model  
Inside the `backend` folder:

- Unzip `model.zip`
- Rename the extracted folder to: my_finbert

### 2. Install dependencies
```shell
pip install -r requirements.txt
```
### Create a .env file in the backend root
```shell
Stock Market API
ALPHA_VANTAGE_API_KEY=your_alpha_vantage_api_key_here

Twitter API (v2)
TWITTER_BEARER_TOKEN=your_twitter_bearer_token_here

News API
NEWS_API_KEY=your_news_api_key_here
```

### Run Backend Server
```shell
python manage.py runserver
```

### The MarketSentimentApp/ folder contains the SwiftUI client app.
Open it in Xcode -> run on macOS.
