=begin
		Copyright 2009 Jeff Welling (jeff.welling (a) gmail.com)
		This file is part of libthetvdb.

    libthetvdb is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    libthetvdb is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with libthetvdb.  If not, see <http://www.gnu.org/licenses/>.
=end
autoload :XmlSimple, 'xmlsimple'
autoload :WWW, 'mechanize'
autoload :ERB, 'erb'   #Used for url encoding

module Thetvdb

  class << self
    #readFile takes a filename, and optionally the maximum number of lines to read.
    #
    #returns the lines read as an array.
    def readFile file, max_lines=0
      counter=0
      read_lines=[]
      File.open(file, 'r') {|f|
        while (line= f.gets and counter<=max_lines)
          read_lines << line
          counter+=1 unless max_lines==0
        end
      }
      read_lines
    end

		def agent(timeout=300)
			a = WWW::Mechanize.new
			a.read_timeout = timeout if timeout
			a.user_agent_alias= 'Mac Safari'
			a   
		end

    #
    def initMirror
      mirrors_xml = XmlSimple.xml_in agent.get("http://www.thetvdb.com/api/#{@apikey}/mirrors.xml").body
      mirrors_xml['Mirror'][0]['mirrorpath'][0]
    end

    def initialize
      @apikey=readFile(File.dirname(__FILE__) +'/apikey.txt', 1).first.strip
      @mirror=initMirror
    end
    attr_reader :apikey, :mirror
  end
  #Search Thetvdb.com for str
  def self.search str
    XmlSimple.xml_in( agent.get("#{@mirror}/api/GetSeries.php?seriesname=#{ERB::Util.url_encode str}").body )
  end
  initialize
end
