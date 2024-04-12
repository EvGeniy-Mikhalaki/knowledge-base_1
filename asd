"""
Module for sending messages to a user's notification channel.
"""

from service_template.src.schemas.auth_data_schema import DefaultAuthDataSchema
from service_template.src.schemas.notification_channel_schema import (
    NotificationChannelExpand,
)
from service_template.src.schemas.sending_schemas import SendingExpand
from service_template.src.schemas.user_schema import UserDB

from api_rest.kafka_manager.connect import k_event


async def user_message_send(user: UserDB, subject: str, message: str):
    """
    Send a message to a user's notification channel.

    :param user: The user to send the message to.
    :param subject: The subject of the message.
    :param message: The content of the message.
    :return: The answer from the message sending process.
    """
    user_connector = NotificationChannelExpand(
        type='email',
        emails=[user.email],
    )
    sending = SendingExpand(
        notification_channel=user_connector,
        text=message,
        subject=subject,
        name='',
    )
    return await k_event.emit_and_wait_for_answer(
        topic='sending_message',
        event='send_message',
        value=sending.json(),
        auth=DefaultAuthDataSchema(user_id=user.id),
    )
