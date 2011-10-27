#!/usr/bin/env perl
use strict;
use warnings;

##############################################################################################################################################################
#
# I built the following in 2 hours for a laugh.  Yes, I was drunk. I may have hit the Balmer peak -- http://xkcd.com/323/ 
#
# "Every band ever used this..." from http://www.reddit.com/r/funny/comments/lplhn/every_band_ever_used_this/
#
# 1- Go to Wikipedia and Hit “Random Article” on the right The first random wikipedia article you get is the name of your band.
#
# 2 - Go to Random quotations Hit refresh, and the last four or five words of the very last quote of the page is the title of your first album.
#
# 3 - Go to flickr and click on “explore the last seven days” Third picture, no matter what it is, will be your album cover.
#
# 4 - Use Photoshop, Paint, or similar to put it all together
#
##############################################################################################################################################################


# Band Name: Random Article on Wikipedia
my $wikipediaArticle=`wget -O-  http://en.wikipedia.org/wiki/Special:Random 2>/dev/null | grep "<title>"`;
$wikipediaArticle =~ s/[\r\n]+/ /mg;
$wikipediaArticle =~ s/\<\/title\>.*$//g;
$wikipediaArticle =~ s/^.*\<title>//g;
$wikipediaArticle =~ s/ [\-(\%\&].*$//g;
my $bandName = $wikipediaArticle;
print "Band Name: $wikipediaArticle\n";

# First Album: Last 4 or 5 words of the last quote on randomized quote page from www.quotationspage.com
my $randomQuotes = `wget -O- http://www.quotationspage.com/random.php3 2>/dev/null` ;
my @splitQuotes = split(/\<dt class=\"quote\"\>/, $randomQuotes);
my $lastQuote = pop @splitQuotes;
$lastQuote =~ s/[\r\n]+/ /mg;
$lastQuote =~ s/^[^\>]*\>//mg;
$lastQuote =~ s/\<.*$//mg;
$lastQuote =~ s/\.$//mg;

my @lastQuoteWords = split(/[\t ]+/, $lastQuote);
my $numWords = 4 + int( rand(2)-0.001);
while(@lastQuoteWords > $numWords)
{
	shift @lastQuoteWords;
}
my $finalQuote = join(" ", @lastQuoteWords);
$finalQuote = (uc substr($finalQuote,0,1)) . substr($finalQuote,1);
my $firstAlbum = $finalQuote;
print "First Album: $finalQuote\n\n";



#Cover Art Image: 3rd picture from last 7 days of Flickr
my $randomFlikrImages=`wget -O- http://www.flickr.com/explore/interesting/7days/ 2>/dev/null`;
$randomFlikrImages=~ s/[\r\n]+/ /mg;
my @splitFlikr=split(/class=\"photo_container pc_m\"/, $randomFlikrImages);
my $imagePageLink=$splitFlikr[3]; # 4th part = 3rd image
$imagePageLink=~ s/^[^\"]*\"//g;
$imagePageLink=~ s/\".*$//g;
$imagePageLink="http://www.flikr.com" . $imagePageLink;
#print "image page link = $imagePageLink\n";

my $imageLink=`wget -O- \"$imagePageLink\" 2>/dev/null`;
$imageLink=~ s/[\r\n]+/ /mg;
$imageLink=~ s/^.*class=\"photo-div\"//g;
$imageLink=~ s/^[^\"]*\"//g;
$imageLink=~ s/\".*$//g;
print "image link = $imageLink\n";



`wget -O cover.jpg \"$imageLink\" 2>/dev/null`;
`convert  -gravity northwest -font helvetica -undercolor white -fill black -pointsize 22 -draw \"text 10,10 \\\"$firstAlbum\\\"\"  cover.jpg new_cover.jpg ; mv new_cover.jpg cover.jpg`;
`convert  -gravity northwest -font helvetica -undercolor white -fill black -pointsize 16 -draw \"text 65,65 \\\"by $bandName\\\"\" cover.jpg new_cover.jpg ; mv new_cover.jpg cover.jpg`;




