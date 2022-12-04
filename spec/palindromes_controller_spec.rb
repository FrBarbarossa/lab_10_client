require_relative 'spec_helper'
require_relative 'rails_helper'
require 'selenium-webdriver'

RSpec.describe PalindromesController do
  include RSpec::Expectations
  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @base_url = 'http://localhost:3000/'
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end

  describe "get index page" do
    context "check index page by root" do
      it 'has code 200' do
        @driver.get @base_url
        expect(@driver.current_url).to eq('http://localhost:3000/')
        
      end
    end
  end
end

RSpec.describe PalindromesController, type: :request do
  describe "get index page" do
    context "check index page by root" do
      it 'has code 200' do
        get 'http://localhost:3000/'
        expect(response).to have_http_status(:success)
        expect(response.status).to eq(200)
      end
    end
  end
end

RSpec.describe PalindromesController, type: :controller do
    
  describe "check result get" do
    context "number given" do
      render_views
      it 'when correct number' do
        get :result, :params => {:number => 100 }
        expect(response.status).to eq(200)
        expect(assigns(:result)).to eq([[1, 1], [2, 4], [3, 9], [11, 121], [22, 484]])
      end

      it 'returns to root if number is not correct' do
        get :result, :params => {:number => -100 }
        expect(response).to redirect_to("/")
      end

    end
  end
end

RSpec.describe "Result table management attempt №3",:js => true, :type => :system do
  before do
    driven_by(:selenium_chrome_headless)
    Capybara.default_max_wait_time = 5
  end

  let (:output) {[1, 2, 3, 11, 22]}
  
  it "user pushed correct number and table created with correct output" do
    visit "/"
    fill_in "number", with: "100"
    click_button ("Find Palindromes")
    # expect(page).to have_selector("table tr td")
    all("table tr td").each_with_index{|val, ind| if (ind - 1) % 3 == 0 then expect(val).to have_text(output[(ind-1)/3]) end}
  end

  it "user input incorrect number and alert showed" do
    visit "/"
    fill_in "number", with: "-100"
    click_button ("Find Palindromes")
    expect(page).to have_selector(class: "lead", text: "Вы ввели: '-100' Введите число, больше 0.")
  end

end