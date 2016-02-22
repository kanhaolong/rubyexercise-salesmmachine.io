require 'httparty'
require 'json'
require_relative 'csv_importer'
require 'csv'    
require 'open-uri'
require 'rest-client'
class Integrationcontact
    def pipedrive(api_token)
     url = "http://api.pipedrive.com/v1/deals?start=0&sort_mode=asc&api_token="+api_token.to_s
     response = HTTParty.get(url)
     json = JSON.parse(response.body)
     if json['success'] = true
     	return json['data']
     end	
    end

    def get_contacts(api_token)
     url = "https://api.pipedrive.com/v1/persons?start=0&api_token="+api_token.to_s
     response = HTTParty.get(url)
     json = JSON.parse(response.body)
    end

    def put_contact(contacts,options={},api_token)
     url = "https://api.pipedrive.com/v1/persons?api_token="+api_token.to_s
     contacts.each do |row|
       name = row['Name']
       email = row['Email']
       options.merge!(:name => name) if name
       options.merge!(:email => email) if email
       puts options
       post = HTTParty.post(url,:body => options.to_json, :headers => {'Content-type' => 'application/json'})
     end
    end

    def delete_contact(id,api_token)
      @url = 'https://api.pipedrive.com/v1/persons/' + id.to_s + '?api_token='+api_token.to_s
      response = HTTParty.delete(@url.to_s)
    end
 
    def update_contact(id,options={},api_token)
       @url = 'https://api.pipedrive.com/v1/persons/' + id.to_s + '?api_token='+api_token.to_s
         
         if (!options.nil?)
           options.merge!(:id => id)
           #puts options          
           response = HTTParty.put(@url.to_s, :body => options.to_json, :headers => {'Content-type' => 'application/json'})
           #puts response        
         end
    end

    def  search_contact(term, org_id,api_token)
     @start = 0;
         contact = Array.new
         @items = true

          tablesize = 0

          while @items == true do
           count = 0
           tempterm = term.to_s.sub!(" ","%20")
                if org_id!=0
                  @url = 'https://api.pipedrive.com/v1/persons/find?term=' + tempterm + '&org_id=' + org_id.to_s + '&start=' + @start.to_s + '&api_token='+api_token.to_s
                else  @url = 'https://api.pipedrive.com/v1/persons/find?term=' + tempterm + '&start=' + @start.to_s + '&api_token='+api_token.to_s
                end
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
               @start = @pagination['next_start']
              end
          end
          return contact
    end
end