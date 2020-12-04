#!/usr/bin/env python3
# -*- coding: iso-8859-15 -*-
from __future__ import (absolute_import, division, print_function)
from ansible.plugins.callback import CallbackBase

__metaclass__ = type

import json
import urllib3
import sys
import os
import requests
import os

myhost = os.uname()[1]
http = urllib3.PoolManager()


DOCUMENTATION = '''
    callback: slack
    options:
      slack_webhook_url:
        required: True
        env:
          - name: SLACK_WEBHOOK_URL
      slack_channel:
        required: False
        env:
          - name: SLACK_CHANNEL
'''


class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 2.0
    CALLBACK_NAME = 'slack_failure'
    CALLBACK_NEEDS_WHITELIST = True

    def __init__(self):
        super(CallbackModule, self).__init__()

    def set_options(self, task_keys=None, var_options=None, direct=None):
        super(CallbackModule, self).set_options(
            task_keys=task_keys, var_options=var_options, direct=direct)

        # Read and assign environment variables to memory so that we can use
        # them later.
        self.slack_webhook_url = os.environ.get('SLACK_WEBHOOK_URL')
        self.slack_channel = os.environ.get('SLACK_CHANNEL')

        if self.slack_webhook_url is None:
            self._display.display(
                'Error: The slack callback plugin requires `SLACK_WEBHOOK_URL` to be defined in the environment')
            sys.exit(1)
        if self.slack_channel is None:
            self._display.display(
                'Error: The slack callback plugin requires `SLACK_CHANNEL` to be defined in the environment')
            sys.exit(1)

    def v2_runner_on_failed(self, taskResult, ignore_errors=False):
        notify(self.slack_webhook_url, taskResult, self.slack_channel)

    def v2_runner_on_unreachable(self, taskResult):
        notify(self.slack_webhook_url, taskResult, self.slack_channel)


def notify(slack_webhook_url, taskResult, slack_channel=None):
    payload = {
        'username': 'Ansible',
        'attachments': [
            {
                'title': 'Ansible run has failed.\n HOST: {}\n {}'.format(myhost, taskResult._task),
                'color': '#FF0000',
                'text': '```{}```'.format(json.dumps(taskResult._result, indent=4))
            }
        ]
    }

    if slack_channel:
        payload['channel'] = slack_channel

    response = requests.post(slack_webhook_url, data=json.dumps(
        payload), headers={'Content-Type': 'application/json'})
