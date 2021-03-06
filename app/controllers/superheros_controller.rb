class SuperherosController < ApplicationController
  def index
    @my_hero = Superhero.create
    @superheros = Superhero.where.not(id: @my_hero.id)

    ActionCable.server.broadcast(
        "superheros",
        id: @my_hero.id,
        name: @my_hero.name,
        power: @my_hero.power,
        weakness: @my_hero.weakness,
    )
  end

  def update
    superhero = Superhero.find(params[:id])
    superhero.update(superhero_params)

    ActionCable.server.broadcast(
        "superheros",
        id: superhero.id,
        name: superhero.name,
        power: superhero.power,
        weakness: superhero.weakness,
    )
  end

  def clear
    Superhero.all.delete_all
    redirect_to superheros_path
  end

  private

  def superhero_params
    params.require(:superhero).permit(:name, :power, :weakness)
  end
end
