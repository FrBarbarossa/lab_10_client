class PalindromesController < ApplicationController
  before_action :check_num, only: :result


  def index
    @result = (1..params[:number].to_i).each.select{|num| if palindrome?(num.to_s) and palindrome?((num**2).to_s) then num end}.map{|i| [i, i**2]}
  end

  def result
    redirect_to '/' unless flash.empty?
    p flash[:notice]
    return unless flash.empty?
    @result = count_result(params[:number].to_i)
  end

  private 

  def check_num
    number = params[:number]
    return if number.nil?
    if Integer(number, exception: false).nil?
      flash[:notice] = "'#{number}' не является числом"
      return
    end
    if number.to_i <= 0  then
      flash[:notice] = "Вы ввели: '#{number}' Введите число, больше 0."
    end
  end

  def palindrome?(str)
    str == str.reverse
  end

  def count_result(number)
    (1..number).each.select { |num| if palindrome?(num.to_s) && palindrome?((num**2).to_s) then num end }.map { |i| [i, i**2] }
  end
end
