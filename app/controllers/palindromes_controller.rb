require 'nokogiri'
require 'open-uri'

class PalindromesController < ApplicationController
  before_action :check_num, only: :result

  def index
  end

  def result
    p request.headers
    @number = params[:number].to_i

    redirect_to '/' unless flash.empty?
    return unless flash.empty?
    
    @side = params[:frmt]
    p @side
    my_url = URL + "?number=#{@number}"
    server_response = URI.open(my_url)
    if @side == 'html'
      @result = xslt_trans(server_response).to_html
    elsif @side == 'xml'
      @result = Nokogiri::XML(server_response)
      render :xml => @result
    elsif @side == 'xslt'
      @result = insert_xslt_line(server_response)
      p "!"
      render :xml => @result
      # render :html => "<h1>PSHL NAH</h1>"
      # render insert_xslt_line(server_response), formats: :xml
    end
  end


  private
  URL = 'http://localhost:3000/palindromes/result.xml'.freeze
  SERV_TRANS = "#{Rails.root}/public/transform.xslt".freeze
  BROWS_TRANS = '/transform.xslt'.freeze

  def xslt_trans(data, transform: SERV_TRANS)
    doc = Nokogiri::XML(data)
    xslt = Nokogiri::XSLT(File.read(transform))
    xslt.transform(doc)
  end

  def insert_xslt_line(data, transform: BROWS_TRANS)
    doc = Nokogiri::XML(data)
    xslt = Nokogiri::XML::ProcessingInstruction.new(
    doc,'xml-stylesheet', 'type="text/xsl" href="' + transform + '"')
    doc.root.add_previous_sibling(xslt)
    doc
  end

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

end
