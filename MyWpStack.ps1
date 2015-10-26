###
# MyWPStack -- Install Wordpress Framework and Tools
# 
###

#
# Global Variables
#

# path to plugins.txt
$pluginfilepath="."

$starterThemeRepo = "https://github.com/J0hnRoger/MyWPStack.Theme.git"
$myThemeRepo = "https://github.com/J0hnRoger/SLHB.git"
$themeName = "SLHB"
$dbName = "wp_slhb"

$adminLogin="Admin-SLHB"
$adminPassword = "SLHB"
$adminEmail = "jonathan.roger4@gmail.com"
$url = "http://slhb.dev"

Write-Host -ForegroundColor DarkGreen "---- MyWPStack, let's start---"

# Get Last Wordpress Release
Write-Host -ForegroundColor DarkGray "1. Get Last Wordpress Release"
cd .\htdocs\cms
#wp core download --locale=fr_FR --force
$WPversion = wp core version
Write-Host -ForegroundColor Green "Version de Wordpress installée : " $WPversion

Write-Host -ForegroundColor DarkGray "2. Create SQL DB"
#wp core config --dbname=$dbName --dbuser=root --dbpass=root --skip-check --extra-php
wp db create

Write-Host -ForegroundColor DarkGray "3. Install Wordpress"
wp core install --url=$url --title=$themeName --admin_user=$adminLogin --admin_email=$adminEmail --admin_password=$adminPassword

Write-Host -ForegroundColor DarkGray "4. Install Plugins from MyWpStackPlugins.txt"
cd ../../

Get-Content MyWpStackPlugins.txt | Foreach-Object{
    wp plugin install $_ --activate
    Write-Host -ForegroundColor Yellow $_ " Installed"
}

Write-Host -ForegroundColor DarkGreen "5. Get Themosis Theme , rename it and activate it"
cd htdocs\content\themes
git clone $starterThemeRepo $themeName
wp theme activate $themeName

cd $themeName
Remove-Item .git -recurse -force

Write-Host -ForegroundColor DarkGreen "6. Attach the theme to the theme repository and add remote"
git init
git add .
git commit -m $themeName "Initial Commit from MyWPStack repo."
git remote add origin $myThemeRepo
git push -u origin master

Write-Host -ForegroundColor DarkGreen "7. Create Develop Branch and switch on it"
git checkout -b develop
git push -u origin develop

Write-Host -ForegroundColor DarkGreen "8. Create Standard Pages"
wp post create --post_type=page --post_title='Accueil' --post_status=publish
wp post create --post_type=page --post_title='Contact' --post_status=publish

Write-Host -ForegroundColor DarkGreen "9. Create Fake Posts"
curl http://loripsum.net/api/5 | wp post generate --post_content --count=5

Write-Host -ForegroundColor DarkGreen "10. Create Menu"
wp menu create "Menu Principal"
wp menu item add-post menu-principal 3
wp menu item add-post menu-principal 4
wp menu item add-post menu-principal 5
wp menu location assign menu-principal main-menu

Write-Host -ForegroundColor DarkGreen "11. Clean Up the default samples (page, post, plugin, themes)"
wp post delete 1 --force 
wp post delete 2 --force 

wp plugin delete hello
wp plugin delete hello
wp plugin delete hello

wp theme delete twentytwelve
wp theme delete twentythirteen
wp theme delete twentyfourteen
wp option update blogdescription ''

Write-Host -ForegroundColor DarkGreen "12.Activate Permalinks"
wp rewrite structure "/%postname%/" --hard
wp rewrite flush --hard

Write-Host -ForegroundColor DarkGreen "13.Update Categories and Tags"
wp option update category_base theme
wp option update tag_base sujet

Write-Host -ForegroundColor DarkGreen "14. Lauch Chrome"
$chrome = (gi ~\AppData\Local\Google\Chrome\Application\chrome.exe ).FullName
$urls = $url, $myThemeRepo
$urls | % { & $chrome $_ }

Write-Host -ForegroundColor Green "MyWpStack Starter Script is successfully finished, Have Fun"