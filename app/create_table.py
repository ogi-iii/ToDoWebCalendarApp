# create_table.py
from models import *
import db
import os

def create_user(username, password, mail):
    # サンプルユーザ(admin)を作成
    admin = User(username=username, password=password, mail=mail)
    db.session.add(admin)  # 追加
    db.session.commit()  # データベースにコミット

    # # サンプルタスク
    # task = Task(
    #     user_id=admin.id,
    #     content='〇〇の締め切り',
    #     deadline=datetime(2019, 12, 25, 12, 00, 00),
    # )
    # print(task)
    # db.session.add(task)
    # db.session.commit()

    db.session.close()  # セッションを閉じる

def create_samples(username, password, mail, content, deadline):
    # サンプルユーザ(admin)を作成
    admin = User(username=username, password=password, mail=mail)
    db.session.add(admin)  # 追加
    db.session.commit()  # データベースにコミット

    # サンプルタスク
    task = Task(
        user_id=admin.id,
        content=content,
        deadline=deadline,
    )
    print(task)
    db.session.add(task)
    db.session.commit()

    db.session.close()  # セッションを閉じる


if __name__ == "__main__":
    path = SQLITE3_NAME
    if not os.path.isfile(path):

        # テーブルを作成する
        Base.metadata.create_all(db.engine)

        # サンプルUser, Taskの作成
        # create_samples(
        # username="admin", 
        # password="password", 
        # mail="sample@mail.com", 
        # content="sample task", 
        # deadline=datetime(2020, 6, 4, 12, 00, 00)
        # )