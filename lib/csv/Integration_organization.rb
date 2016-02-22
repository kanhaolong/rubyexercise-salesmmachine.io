require 'httparty'
require 'json'
require_relative 'csv_importer'
require 'csv'    
require 'open-uri'
require 'rest-client'

class Organization	
	def addOrganization(cName, options = {},api_token) 
		uri = URI.parse('https://api.pipedrive.com/v1/organizations?api_token=' + api_token.to_s)
			if (!options.nil?)
				options.merge!(:name => cName)
				response = Net::HTTP.post_form(uri, options)
			end
	end

	def getOrganization(id,api_token)
		begin
			@url = 'https://api.pipedrive.com/v1/organizations/' + id.to_s + '?api_token=' + api_token.to_s

			@context = open(@url.to_s).read

			@post = JSON.parse(@context)
			if @post["data"].nil?
				return "Organization does not exist in pipedrive"
			else
				return @post
			end
		rescue OpenURI::HTTPError => error
					response = error.io
					return response.status
		end
	end

	def findOrganizationByName(name,api_token)
		begin
			@start = 0
					  
			table = Array.new
			@more_items = true
			tablesize = 0

			while @more_items == true do
					count = 0

					@url = URI.parse('https://api.pipedrive.com/v1/organizations/find?term=' + name+ '&start=' + @start.to_s + '&limit=500&api_token=' + api_token.to_s)

					@content = open(@url.to_s).read

							#puts @content

							@parsed = JSON.parse(@content)

							while count < @parsed["data"].size
									#table.push(@parsed["data"][count])
									table[tablesize] = @parsed["data"][count]
									count = count +1
									tablesize = tablesize + 1
									
							end	
									@pagination = @parsed['additional_data']['pagination']
									@more_items = @pagination['more_items_in_collection']
									#puts @more_items
									@start = @pagination['next_start']
									#puts @start
									end
							return table

			rescue OpenURI::HTTPError => error
					response = error.io
					return response.status
			end
	end

	def getPersonsOfOrganization(id,api_token)
			begin
					@start = 0
				  
					table = Array.new
					@more_items = true
					tablesize = 0

					while @more_items == true do
							count = 0

							@url = 'https://api.pipedrive.com/v1/organizations/' + id.to_s + '/persons?&start=' + @start.to_s + '&limit=500&api_token='+api_token
											
							@content = open(@url.to_s).read

							puts @content

							@parsed = JSON.parse(@content)

							if @parsed["data"].nil?
								return "Organization does not have any Person associated with that id"
							else
					
									while count < @parsed["data"].size
										#table.push(@parsed["data"][count])
										table[tablesize] = @parsed["data"][count]
										count = count +1
										tablesize = tablesize + 1
									end	
								@pagination = @parsed['additional_data']['pagination']
								@more_items = @pagination['more_items_in_collection']
								#puts @more_items
								@start = @pagination['next_start']
								#puts @start                                                                                                                                                                                                                       
							end
					end
					return table
				rescue OpenURI::HTTPError => error
						response = error.io
						return response.status
				end
	end

	def updateOrganization(id,options = {},api_token)
			@url = 'https://api.pipedrive.com/v1/organizations/' + id.to_s + '?api_token=' + api_token.to_s
			if (!options.nil?)
					options.merge!(:id => id)
					response = HTTParty.put(@url.to_s, :body => options.to_json, :headers => {'Content-type' => 'application/json'})			
			end
	end
end

#=begin
#Organization=Organization.new
#Organization.addOrganization("Slaesmachine",{},'8247c424fe7ae35f57797aa5720c90c3c8baa850')
#puts Organization.getOrganization(4,'8247c424fe7ae35f57797aa5720c90c3c8baa850')["data"]["name"]
#puts Organization.findOrganizationByName("new",'8247c424fe7ae35f57797aa5720c90c3c8baa850')
#puts Organization.getPersonsOfOrganization(4,'8247c424fe7ae35f57797aa5720c90c3c8baa850')
#Organization.updateOrganization(2,{:name=>"new"},'8247c424fe7ae35f57797aa5720c90c3c8baa850')
#getOrganization
#=end