###
# MyWPStack -- Install Wordpress Framework and Tools
# 
###

#
# Please, Fill these variables :
#

#Local Web Server 
$localDomain = "slhb.dev"

#GitHub
$myThemeRepo = "https://github.com/J0hnRoger/SLHB.git"
$themeName = "SLHB"

#MySQL
$dbName = "wp_slhb"
$dbAdminLogin = "root"
$dbAdminPassword = ""

#WordPress
$adminLogin="Admin-SLHB"
$adminPassword = "SLHB"
$adminEmail = "jonathan.roger4@gmail.com"

# path to plugins.txt
$pluginfilepath="."

# It looks good, you can execute your script
###
# MYWPSTART CODE
# 
###

$starterThemeRepo = "https://github.com/J0hnRoger/MyWPStack.Theme.git"

Write-Host -ForegroundColor DarkGreen "---- MyWPStack, let's start---"

Write-Host -ForegroundColor DarkGray "0. Dev' Environment Configuration"

$HostName = hostname;

ReplaceTag ".\.env.local.php" "%DBNAME%" $dbName
ReplaceTag ".\.env.local.php" "%DBADMIN%" $dbAdminLogin
ReplaceTag ".\.env.local.php" "%DBPASSWORD%" $dbAdminPassword
ReplaceTag ".\.env.local.php" "%SERVER_NAME%" $localDomain
ReplaceTag ".\config\environment.php" "%HOSTNAME%" $HostName

Write-Host -ForegroundColor DarkGray "1. Get Last Wordpress Release"
cd .\htdocs\cms
#wp core download --locale=fr_FR --force
$WPversion = wp core version
Write-Host -ForegroundColor Green "Version de Wordpress installée : " $WPversion

Write-Host -ForegroundColor DarkGray "2. Create SQL DB"

#wp core config --dbname=$dbName --dbuser=root --dbpass=root --skip-check --extra-php
cd ../../
wp db create

Write-Host -ForegroundColor DarkGray "3. Install Wordpress"
wp core install --url='http://'.$localDomain --title=$themeName --admin_user=$adminLogin --admin_email=$adminEmail --admin_password=$adminPassword

Write-Host -ForegroundColor DarkGray "4. Install Plugins from MyWpStackPlugins.txt"

Get-Content MyWpStackPlugins.txt | Foreach-Object{
    wp plugin install $_ --activate
    Write-Host -ForegroundColor Yellow $_ " Installed"
}

Write-Host -ForegroundColor DarkGreen "5. Get Themosis Theme , rename it and activate it"

cd htdocs\content\themes

git clone $starterThemeRepo $themeName
wp theme activate $themeName

cd $themeName

Write-Host -ForegroundColor DarkGreen "6. Attach the theme to the new Theme repository and add remote"

Remove-Item .git -recurse -force

git init
git add .
git commit -m "Initial Commit from MyWPStack repo."
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
wp theme delete twentytwelve
wp theme delete twentythirteen
wp theme delete twentyfourteen

Write-Host -ForegroundColor DarkGreen "12.Activate Permalinks"
wp rewrite structure "/%postname%/" --hard
wp rewrite flush --hard

Write-Host -ForegroundColor DarkGreen "13.Update Categories and Tags"
wp option update category_base theme
wp option update tag_base sujet

Write-Host -ForegroundColor DarkGreen "13.Install NPM & Bower Dependencies"
npm install
bower install

Write-Host -ForegroundColor DarkGreen "14. Update GulpFile with Theme Name"

ReplaceTag './gulpfile.js' '%SERVER_NAME%' $localDomain
ReplaceTag './gulpfile.js' '%THEME_NAME%' $themeName

Write-Host -ForegroundColor DarkGreen "14. Lauch Gulp"

gulp inject
gulp

Write-Host -ForegroundColor Green "MyWpStack Starter Script is successfully finished, Have Fun"

Read-Host ""

#### Utils Function 

function ReplaceTag($filePath, $tag, $value)
{
    (Get-Content $filePath) | 
    Foreach-Object {$_ -replace $tag, $value} | 
    Out-File $filePath
}
