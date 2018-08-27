#!/bin/env python
import tweepy
import binascii

out_file = "blue_shadow_data"

consumer_key = "..."
consumer_secret = "..."
access_token = "..."
access_secret = "..."

if __name__ == "__main__":
    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_secret)

    api = tweepy.API(auth)

    blue_shadow = api.get_user('blue_shad0w_')
    tweets_count = blue_shadow.statuses_count
    tweets = api.user_timeline(screen_name = 'blue_shad0w_', count = tweets_count, tweet_mode='extended')

    fd = open(out_file, "wb");
    while tweets_count >= 0:
        tweets_count -= 1
        data = tweets[tweets_count].full_text
        i = 0
        while i <= len(data)-1:
            s = data[i:i+8]
            fd.write(chr(int(s,2)))
            i += 8

    fd.close()
