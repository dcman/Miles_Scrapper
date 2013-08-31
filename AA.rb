class AA
  require 'mechanize'
  require 'cacert'
 
  @@miles       = []
  aam_location  = '//*[@id="summaryData"]/table/tbody/tr[8]/td[2]'  #Location on your current miles
  exp_location  = '//*[@id="summaryData"]/table/tbody/tr[4]/td[1]'  #Location of the exp date 
  mms_location  = '//*[@id="summaryData"]/table/tbody/tr[7]/td[2]'  #Location of Million mile status
  @login         = 'Username' #Enter your login name with single quote around it
  @pass          = 'Password' #Enter your password with single quotes around it



 def run
     agent = Mechanize.new do |a| #Creatting new Mechanize object
       a.ssl_version = "SSLv3"  #Setting up SSL
       a.ca_file = Cacert.pem   #Setting the cert path
   end

 page = agent.get('https://aa.com/') #loads American Airlines home page
 page = agent.page.link_with(:text => 'My Account').click #loads log in page
 log_in_form = page.forms[2] #finds the log in form
 log_in_form.loginId = @login #entering login
 log_in_form.password = @pass #entering pass
 page = agent.submit(log_in_form) #submiting
 page = agent.page.link_with(:text => 'My Account').click #loading my acount
 page = agent.page.link_with(:text => 'View My Miles').click #loading milles page
 @@miles.push(page.search(aam_location).text) #Saving current miles to @@miles
 text = page.search(exp_location).text #Findding exp date
 @@miles.push(text.gsub(/[[:space:]]/, ' ').gsub(
        '         ','').gsub('Miles with Expiration Deferred Through','')) #Formaing and saving exp date
 @@miles.push(page.search(mms_location).text) #Saving million mile to @@miles

 end
  def miles
    return @@miles
  end
end