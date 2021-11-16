

from urllib.request import urlopen, Request
from html.parser import HTMLParser
import collections


class CDMParser(HTMLParser):
    
    "Parses the HTML of CDM website and populates a dictionary with words and ther counts"
    
    search_tags = ['p','div', 'span', 'a', 'h1','h2','h3','h4', 'table', 'td']
    
    small_words = ['the','and','with', 'their', 'who', 'for', 'has', 'our', 'are', 'that']
    
    current_tag = ''
    
    #a dictionary to hold the words and their counts
    popular_words = {}
    
    def handle_starttag(self, tag, attribute):
        
        "initialize the start tag"
        
        self.current_tag = tag
        
    def handle_data(self, data):
        
        "cleans up the data"
        
        if self.current_tag in self.search_tags:
            
            for word in data.strip().split():
                
                #lower case all the words and remove unneeded things like full stops and commas
                popular_word = word.lower().replace('.', '').replace(':', '').replace(',', '')
                
                #filter out small words and unneeded words like the, and
                if self.search_word(popular_word):
                
                      if popular_word not in self.popular_words:
                          self.popular_words[popular_word] = 0
                    
                      self.popular_words[popular_word] += 1
       
    def search_word(self, word):
        
        "filters out data with small words and numbers"
        
        return len(word) > 2 and word not in self.small_words and word[0].isalpha()
          
                       
#traget URL
url = 'https://www.cdm.depaul.edu/Pages/default.aspx'
    
req = Request(url, headers={'User-Agent': 'XYZ/3.0'})
    
response = urlopen(req, timeout = 20)
    
#get the html
html = response.read().decode('utf-8', errors = 'ignore')
    
#create an instance of CDMParser
parser = CDMParser()
    
#feed the html through my parser
parser.feed(html)
    
#count each word in the dictionary
count = collections.Counter(parser.popular_words)
    
common = count.most_common(25)
    
for word, count in common:
    print(word, count, sep = ": ")
        



        
        
        
    
    
    
    
   
   
    
    
