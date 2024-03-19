FROM python:alpine3.19
COPY ./app/requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt
COPY ./app /app
CMD python3 -m gunicorn -w 3 -b 0.0.0.0:8000 main:app
