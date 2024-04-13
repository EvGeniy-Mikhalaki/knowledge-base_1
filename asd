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

# @handler.post("/upload-csv/")
# async def upload_csv(file: UploadFile = File(...), db: Session = Depends(get_async_session)):
#     if file.content_type != "text/csv":
#         return JSONResponse(status_code=400, content={"message": "Only CSV files allowed"})
#     try:
#         data = await file.read()
#         parsed_region_in = await parse_csv(data)
#         data_regions = await pars_data_region(data_pars=parsed_region_in)
#         # print(data_regions)
#         await save_db_region(db_session=db, data=data_regions)
#         return JSONResponse(status_code=201, content={"message": f"Regions recorded in the database"})
#     except Exception as e:
#         return JSONResponse(status_code=500, content={"message": f"Error processing CSV file: {str(e)}"})




# async def parse_csv(file) -> ParsRegionIn:
#     reader = csv.reader(StringIO(file.decode('utf-8')))
#     columns = next(reader)
#     data = list(reader)[1:]

#     return ParsRegionIn(data_for_pars=data,
#         i_region = find_index_of_column(columns, 'Субъект'),
#         i_company = find_index_of_column(columns, '2022_прибыль'),
#         i_bankruptcy = find_index_of_column(columns, 'введена процедура банкротства/ликвидация'),
#         i_tax_arrears = find_index_of_column(columns, 'задолженность по налогам'),
#         i_need_capital = find_index_of_column(columns, 'потребность в оборотных средствах'),
#         i_repayment = find_index_of_column(columns, 'расчёт возвратности средств для кредиторов')
#     )

# async def save_db_region(db_session: AsyncSession, data: list):
#     await db_session.execute(Region.__table__.delete())

#     for elem in data:
#         db_region = Region(
#             name_ragion=str(elem.name_ragion),
#             number_le=int(elem.number_le),
#             number_company=int(elem.number_company),
#             number_bankrupt=int(elem.number_bankruptcy),
#             amount_debt=float(round(elem.amount_debt, 3)),
#             amount_need_capital=float(round(elem.amount_need_capital, 3)),
#             amount_repayment=float(round(elem.amount_repayment, 3)),
#         )
#         db_session.add(db_region)
#     await db_session.commit()

# async def save_db_region(db_session: AsyncSession, data: list):
#     await db_session.execute(Region.__table__.delete())

#     for elem in data:
#         # Проверяем превышение чисел перед присвоением
#         number_le = min(int(elem.number_le), 9223372036854775807)
#         number_company = min(int(elem.number_company), 9223372036854775807)
#         number_bankrupt = min(int(elem.number_bankruptcy), 9223372036854775807)
#         amount_debt = float(round(elem.amount_debt, 3))
#         amount_need_capital = float(round(elem.amount_need_capital, 3))
#         amount_repayment = float(round(elem.amount_repayment, 3))

#         # Создаем объект Region с проверенными значениями
#         db_region = Region(
#             name_ragion=str(elem.name_ragion),
#             number_le=number_le,
#             number_company=number_company,
#             number_bankrupt=number_bankrupt,
#             amount_debt=amount_debt,
#             amount_need_capital=amount_need_capital,
#             amount_repayment=amount_repayment,
#         )
#         db_session.add(db_region)

#     await db_session.commit()
