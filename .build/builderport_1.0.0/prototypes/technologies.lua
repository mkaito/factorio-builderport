data:extend({
  {
    type = "technology",
    name = "builderport",
    icon_size = 128,
    icon = "__base__/graphics/technology/robotics.png",
    effects = {
      {
        type = "unlock-recipe",
        recipe = "builderport"
      }
    },
    prerequisites = { "construction-robotics", "logistic-robotics", "logistic-system" },
    unit = {
      count = 1500,
      ingredients = {
        { "science-pack-1", 1 },
        { "science-pack-2", 1 },
        { "science-pack-3", 1 },
        { "production-science-pack", 1 },
        { "high-tech-science-pack", 1 }
      },
      time = 60
    },
    order = "c-k-d"
  }
})
