from datetime import datetime, timedelta, timezone
from lib.ddb import Ddb
from lib.db import db

class Messages:
  def run(message_group_uuid, cognito_user_id):
    printh("Messages.run() ...")
    model = {
      'errors': None,
      'data': None
    }

    sql = db.template('users', 'uuid_from_cognito_user_id')
    current_user_uuid = db.query_value(sql, { 
        'cognito_user_id': cognito_user_id 
    })

    ddb_client = ddb.client()
    data = ddb.list_messages(ddb_client, message_group_uuid)
    model['data'] = data
    return model