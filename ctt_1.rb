require 'test/unit'
require 'selenium-webdriver'

#Test case
# 1. Go to http://juke.com/
# 2. Accept cookies and navigate to <registration page>
# 3. Register user using email / password
# !!! Check that user is registered correctly
# 4. Navigate to site's homepage
# 5. Start playback on a random item#
# !!! Check that playback was started

class Ciklum_testTask < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Chrome driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-translate')
    c_path = Dir.pwd
    #Selenium::WebDriver::Chrome.driver_path = c_path + "/chromedriver.exe"
    Selenium::WebDriver::Firefox.driver_path = c_path + "/geckodriver.exe"
    #@driver = Selenium::WebDriver.for :chrome, options: options

    @f_driver = Selenium::WebDriver.for :firefox, options: options
    #@driver.manage.window.maximize
    #@driver.navigate.to "https://juke.com/de/start"

    @regMail = "testLogin@gmail.com"
    @regPass = "testPassword_123"

  end

  def test_registration
    #user name field
    #page.click_link('', :href => '/de/registration/sign-up/')
    #page.find(:css, 'a[href="/de/registration/sign-up"]').click

    regBtn = @driver.find_element(:link_text, "Registrieren")
    regBtn.click
    #puts "REDIRECTED"

    #@driver.navigate.to "https://juke.com/de/registration/sign-up"
    @f_driver.navigate.to "https://juke.com/de/registration/sign-up"

    #eMailInput = @driver.find_element(:id,'registration-email')
    # eMailInput.send_keys('testLogin')
    f_eMailInput = @f_driver.find_element(:id, 'registration-email')
    f_eMailInput.send_keys(@regMail)


    #ePassInput = @driver.find_element(:id,'registration-password')
    #ePassInput.send_keys('testPassword')

    f_eMailInput = @f_driver.find_element(:id, 'registration-password')
    f_eMailInput.send_keys(@regPass)

    if !@f_driver.find_element(:id, 'registration-terms').selected?
      f_termsChBx = @f_driver.find_element(:id, '#registration-terms')
      f_termsChBx.click
    end

    #Scenario where user want get newsletter
    if !@f_driver.find_element(:id, 'registration-newsletter').selected?
      f_termsChBx = @f_driver.find_element(:id, 'registration-newsletter')
      f_termsChBx.click
    end

    f_submitBtn = @f_driver.find_element(:xpath,'/html/body/div[5]/div[2]/div/div[1]/div[1]/form/div/footer/common-button/button')
    f_submitBtn.click

    #wait for redirection
    wait = Selenium::WebDriver::Wait.new(:timeout => 15)

    #check our form (header should contain registered mail, should be shown welcome message)
    form = wait.until {
      mail_element = @f_driver.find_element(:xpath, "/html/body/div[5]/div[1]/div/header").get_text
      mail_element if element.get_text == @regMail

      welcome_element = @f_driver.find_element(:xpath, "/html/body/div[5]/div[2]/div/div[1]/div[2]/h1").get_text
      welcome_element if element.get_text == "WILLKOMMEN BEI JUKE!"
    }

    puts "Registration Passed: registered email found" if form.displayed?

    #Redirect to the home page by clicking on the header logo
    @f_driver.find_element(:xpath, "/html/body/div[2]/div[2]/header/div[2]/a").click

    #Wait for redirection complete
    wait = Selenium::WebDriver::Wait.new(:timeout => 15)
    #Click playback
    @f_driver.find_element(:xpath, "//*[@id=\"player-container\"]/div/div[7]/div").click
    #Check if time go up in the corresponded div
    if @f_driver.find_element(:xpath, "//*[@id=\"player-container\"]/div/div[9]").get_text != "0:00"
      puts "Playback checking Passed"
    end

  end

  def teardown
    @driver.quit
  end

  def test_fail
    fail('Not implemented')
  end
end