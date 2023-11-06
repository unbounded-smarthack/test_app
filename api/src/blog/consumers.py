import json
import logging

from channels.generic.websocket import AsyncWebsocketConsumer


class CommentConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.blog_id = self.scope['url_route']['kwargs']['blog_id']
        self.blog_group_name = f'blog_{self.blog_id}'

        #TODO Get first page of existing comments from database and sort by date
        comments = ["Already existing comment 1", "Already existing comment 2"]

        await self.channel_layer.group_add(
            self.blog_group_name,
            self.channel_name
        )

        await self.accept()
        for comment in comments:
            await self.send(text_data=json.dumps({
                'message': comment
            }))

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.blog_group_name,
            self.channel_name
        )

    async def receive(self, text_data = None, bytes_data = None):
        #TODO save to dabase

        #TODO send to group
        await self.channel_layer.group_send(
            self.blog_group_name,
            {
                'type': 'comment_message',
                'message': text_data
            }
        )
        logging.info(f'CommentConsumer: {text_data}')

    async def comment_message(self, event):
        message = event['message']
        await self.send(text_data=message)
