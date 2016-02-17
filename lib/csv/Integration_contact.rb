require 'httparty'
require 'json'
require_relative 'csv_importer'
require 'csv'    
require 'open-uri'
require 'rest-client'
class Integrationcontact
    def pipedrive
    	url = "http://api.pipedrive.com/v1/deals?start=0&sort_mode=asc&api_token=8247c424fe7ae35f57797aa5720c90c3c8baa850"
     response = HTTParty.get(url)
     json = JSON.parse(response.body)
     if json['success'] = true
     	return json['data']
     end	
    end

    def get_contacts
    	url = "https://api.pipedrive.com/v1/persons?start=0&api_token=8247c424fe7ae35f57797aa5720c90c3c8baa850"
     response = HTTParty.get(url)
     json = JSON.parse(response.body)
     #puts json
    end

    def put_contact(contacts,options={})
     #contact = contact.to_json
     url = "https://api.pipedrive.com/v1/persons?api_token=8247c424fe7ae35f57797aa5720c90c3c8baa850"
     contacts.each do |row|
       name = row['Name']
       email = row['Email']
       options.merge!(:name => name) if name
       options.merge!(:email => email) if email
       puts options
       post = HTTParty.post(url,:body => options.to_json, :headers => {'Content-type' => 'application/json'})
     end
    end
  
    def delete_contact(id)
      @url = 'https://api.pipedrive.com/v1/persons/' + id.to_s + '?api_token=8247c424fe7ae35f57797aa5720c90c3c8baa850' 
      response = HTTParty.delete(@url.to_s)
    end
 
   def update_contact(id,options={})
       @url = 'https://api.pipedrive.com/v1/persons/' + id.to_s + '?api_token=8247c424fe7ae35f57797aa5720c90c3c8baa850'
         
         if (!options.nil?)
           options.merge!(:id => id)
           #puts options          
           response = HTTParty.put(@url.to_s, :body => options.to_json, :headers => {'Content-type' => 'application/json'})
           #puts response        
         end
    end

    def  search_contact(term, org_id)
     @start = 0;
         contact = Array.new
         @items = true

          tablesize = 0

          while @items == true do
           count = 0
           tempterm = term.to_s.sub!(" ","%20")
                if org_id!=0
                  @url = 'https://api.pipedrive.com/v1/persons/find?term=' + tempterm + '&org_id=' + org_id.to_s + '&start=' + @start.to_s + '&api_token=8247c424fe7ae35f57797aa5720c90c3c8baa850'
                else  @url = 'https://api.pipedrive.com/v1/persons/find?term=' + tempterm + '&start=' + @start.to_s + '&api_token=8247c424fe7ae35f57797aa5720c90c3c8baa850'
                end
             #@base = 'https://api.pipedrive.com/v1/persons/find?term=123&start=1&api_token=8247c424fe7ae35f57797aa5720c90c3c8baa850'
             @content = open(@url.to_s).read
             @post = JSON.parse(@content)

             if @post["data"].nil?
              return "No Persons returned"
             else
                while count < @post["data"].size
                 contact[tablesize] = @post["data"][count]
                 count = count +1
                 tablesize = tablesize + 1
               end 
               @pagination = @post['additional_data']['pagination']
               @items = @pagination['more_items_in_collection']
               #puts @more_items
               @start = @pagination['next_start']
               #puts @start
              end
          end
          return contact
    end
end
=begin
  importer = CsvImporter.new
  contacts = importer.import(csv_file: 'contacts.csv')
  Intergrationforcontact = Integrationcontact.new
     # email = row['Email']
     # id = row['data']['Id']
     # city = row['data']['City']
     #put_contact(contacts)
     #delete_contact(2)
     #updatePerson(3,{:name => "newone"})
     #contactually_get_contacts
     get_contacts = Intergrationforcontact.get_contacts
  puts Intergrationforcontact.search_contact('newone',0)
=end
