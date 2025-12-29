from flask import Flask, request
from flask_restx import Api, Resource, fields
import requests
import uuid
import time

app = Flask(__name__)

api = Api(
    app,
    title="Recipe API",
    version="1.0.0",
    description="Recipe backend with Swagger support",
    doc="/docs"
)

MEALDB_BASE_URL = "https://www.themealdb.com/api/json/v1/1"

ns = api.namespace("api/meals", description="Meals operations")


meal_response = api.model("MealResponse", {
    "meals": fields.Raw(description="Meal list returned from TheMealDB")
})


@ns.route("/random")
class RandomMeal(Resource):
    @ns.response(200, "Success", meal_response)
    @ns.response(500, "MealDB error")
    def get(self):
        res = requests.get(f"{MEALDB_BASE_URL}/random.php", timeout=10)
        if res.status_code != 200:
            api.abort(500, "MealDB error")
        return res.json()


@ns.route("/search")
class SearchMeals(Resource):
    @ns.param("q", "Search query", required=True)
    @ns.response(200, "Success", meal_response)
    @ns.response(400, "Missing query")
    def get(self):
        q = request.args.get("q")

        if not q:
            api.abort(400, "Missing query parameter: q")

        res = requests.get(
            f"{MEALDB_BASE_URL}/search.php",
            params={"s": q},
            timeout=10
        )

        if res.status_code != 200:
            api.abort(500, "MealDB error")

        return res.json()


@ns.route("/<string:meal_id>")
class MealById(Resource):
    @ns.response(200, "Success", meal_response)
    @ns.response(404, "Meal not found")
    @ns.response(500, "MealDB error")
    def get(self, meal_id):
        res = requests.get(
            f"{MEALDB_BASE_URL}/lookup.php",
            params={"i": meal_id},
            timeout=10
        )

        if res.status_code != 200:
            api.abort(500, "MealDB error")

        data = res.json()

        if data.get("meals") is None:
            api.abort(404, "Meal not found")

        return data
    
    # =========================================================
# USER RECIPES (YENİ – HYBRID İÇİN)
# =========================================================

user_ns = api.namespace(
    "api/user-recipes",
    description="User created recipes"
)

user_recipe_request = api.model("UserRecipeCreate", {
    "name": fields.String(required=True),
    "thumbnail": fields.String,
    "instructions": fields.String,
    "category": fields.String,
    "area": fields.String,
    "ingredients": fields.List(fields.String, required=True),
})

user_recipe_response = api.model("UserRecipe", {
    "id": fields.String,
    "name": fields.String,
    "thumbnail": fields.String,
    "instructions": fields.String,
    "category": fields.String,
    "area": fields.String,
    "ingredients": fields.List(fields.String),
    "createdAt": fields.Integer,
    "updatedAt": fields.Integer,
})

# Basit in-memory store (şimdilik)
USER_RECIPES_STORE = {}


@user_ns.route("")
class UserRecipes(Resource):

    @user_ns.marshal_list_with(user_recipe_response)
    def get(self):
        return list(USER_RECIPES_STORE.values())

    @user_ns.expect(user_recipe_request)
    @user_ns.marshal_with(user_recipe_response, code=201)
    def post(self):
        data = request.json

        now = int(time.time() * 1000)
        recipe_id = str(uuid.uuid4())

        recipe = {
            "id": recipe_id,
            "name": data["name"],
            "thumbnail": data.get("thumbnail", ""),
            "instructions": data.get("instructions", ""),
            "category": data.get("category", ""),
            "area": data.get("area", ""),
            "ingredients": data["ingredients"],
            "createdAt": now,
            "updatedAt": now,
        }

        USER_RECIPES_STORE[recipe_id] = recipe
        return recipe, 201

@user_ns.route("/<string:recipe_id>")
class UserRecipeById(Resource):

    def delete(self, recipe_id):
        USER_RECIPES_STORE.pop(recipe_id, None)
        return "", 204
    
    

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050, debug=True)



