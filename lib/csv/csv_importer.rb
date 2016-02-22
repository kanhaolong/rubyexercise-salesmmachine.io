require 'csv'
require_relative '../importer'
# You have to implement this class
class CsvImporter < Importer
	def import(options)
		array = []
		hash= {}
		hash1 = {}
		if options.keys.include?(:csv_file)
    		CSV.foreach(options[:csv_file],encoding:"UTF-8",:headers => true) do |row|
    			h1 = Array.new(row.headers)
    			f1 = Array.new(row.fields)
    			h1.delete_at(1)
    			f1.delete_at(1)
    			h1.delete_at(1)
    			f1.delete_at(1)
    		    hash['data'] = {}
    		    hash['data'] = Hash[h1.zip(f1)]
    		    hash1=Hash[row.headers[1..-2].zip(row.fields[1..-2])]
    		    hash1 = hash1.merge(hash)
    		    array.push(hash1)
    		end
    	end
    	array
	end
end