require 'uri'
require 'json'
require 'net/http'

class GamesController < ApplicationController
  LIEN = 'https://wagon-dictionary.herokuapp.com/'.freeze
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @letters = JSON.parse(params[:grid])
    # fonction de vérification de la présence des lettres dans le mot
    if check_letters?(params[:word], JSON.parse(params[:grid])) && check_word?(params[:word])
      @result = "Congratulations! #{params[:word]} is a word!"
      @score = 2 ** params[:word].length
      session[:score] = session[:score].to_i + @score
      @answer = 'Your score is :'
    elsif check_letters?(params[:word], JSON.parse(params[:grid]))
      @result = "Sorry but #{params[:word]} does not seem to be a valid English word..."
      @answer = 'Sorry you lose, your score is now:'
      session[:score] = 0
    else
      @result = "Sorry but #{params[:word]} can't be built with this grid"
      @answer = 'Sorry you lose, your score is now:'
      session[:score] = 0
    end
  end

  private

  def check_word?(word)
    url = URI("https://wagon-dictionary.herokuapp.com/#{word}")
    response = JSON.parse(Net::HTTP.get(url))
    response['found']
  end

  def check_letters?(word, letters)
    word.split('').each do |letter|
      return false unless letters.include?(letter.upcase)
    end
  end
end
