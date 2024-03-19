from flask import Flask, request, render_template

from geocoding import GeoCoding, NotFoundException
from forecast import Forecast

# Init flask
app = Flask(__name__)

@app.route('/')
def main():
    """ Main index """
    args = request.args
    if "search" in args.keys() and len(args['search']) > 0:  # Check if search was provided
        try:
            # Get Geocoding
            geocoding = GeoCoding.find(args["search"])
        except NotFoundException:
            # Render template with not found
            return render_template("main.html", search=args["search"], forecast=None)
        else:
            # Get forecast
            forecast = Forecast.get(geocoding, 7)
            # Render template with forecast
            message = None
            if "msg" in args.keys():
                message = args['msg']

            return render_template("main.html", search=args["search"],
                                    forecast=forecast, message=message)

    return render_template("main.html")

if __name__ == "__main__":
    # Runs the flask app
    app.run()
