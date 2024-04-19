from flask import Flask, jsonify, request
from agora_token_builder import build_token

app = Flask(__name__)

from agora_access_token import AccessToken, RtcTokenBuilder, RtmTokenBuilder
import time

APP_ID = ''
APP_CERTIFICATE = ''

def build_rtc_token(user_id, channel_name):

    expiration_time_in_seconds = 86400
    current_time = int(time.time())
    privilege_expired_ts = current_time + expiration_time_in_seconds

    rtc_token = RtcTokenBuilder.buildTokenWithAccount(APP_ID, APP_CERTIFICATE, channel_name, user_id, RtcTokenBuilder.Role.Publisher, privilege_expired_ts)
    
    return {
        "token": rtc_token
    }

def build_rtc_token(user_id, channel_name):

    expiration_time_in_seconds = 86400
    current_time = int(time.time())
    privilege_expired_ts = current_time + expiration_time_in_seconds

    rtm_token = RtmTokenBuilder.buildToken(APP_ID, APP_CERTIFICATE, user_id, RtmTokenBuilder.Role.Rtm_User, privilege_expired_ts)
    
    return {
        "token": rtm_token
    }

@app.route('/get_rtc_token', methods=['POST'])
def get_rtc_token():
    user_id = request.json.get('user_id')
    channel_name = request.json.get('channel_name')
    
    token = build_rtc_token(user_id, channel_name)
    
    return jsonify(token=token)

@app.route('/get_rtm_token', methods=['POST'])
def get_rtm_token():
    user_id = request.json.get('user_id')
    channel_name = request.json.get('channel_name')
    
    token = build_rtm_token(user_id, channel_name)
    
    return jsonify(token=token)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081, debug=True, ssl_context=('vcm-39030.vm.duke.edu_root_last.pem', 'vcm-39030.vm.duke.edu.key'))