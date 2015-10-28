MyWpStacjk framework
------------------

#### Wamp Installation 

1. Set the virtual Host : [WAMP](https://www.kristengrote.com/blog/articles/how-to-set-up-virtual-hosts-using-wamp) 
2. [Get Node & NPM](https://nodejs.org/en/) and take care to fill the "include in my path" checkbox
3. [Download WP-CLI](https://github.com/wp-cli/wp-cli/wiki/Alternative-Install-Methods) - I personnaly use [Composer](https://getcomposer.org/download/) then, run `composer create-project wp-cli/wp-cli --no-dev`  
4. Go to your Path Variables : Panneau de configuration\Système et sécurité\Système > Paramètres système avancés > Variables d'environnement and add the following tool in your path : 
    - PHP  -> C:\wamp\bin\php\php5.5.12\
	- MySQL -> C:\wamp\bin\mysql\mysql5.6.17\bin
	- WP-CLI -> D:\Installs\wp-cli\bin 
5. Update the `MyWpStack.PS1` script with your own values

### Optionnal
- You can set an empty GitHub Repository for sourcing your new Theme.

Themosis framework
------------------

Themosis framework is a tool to help you develop websites and web applications faster using [WordPress](http://wordpress.org). Using an elegant and simple code syntax, Themosis framework helps you structure and organize your code and allows you to better manage and scale your WordPress websites and applications.

Themosis framework uses “modern” PHP features like anonymous functions, namespaces, is [Composer](https://getcomposer.org/) ready and is a mix between WordPress best practices and let’s say a typical MVC framework.

The Themosis framework is born to give WordPress developers the development joy found in the [Laravel](http://laravel.com/) framework to WordPress development. As WordPress developers, you are happy by definition. Now with the Themosis framework you'll be happier and you'll be able to provide more features to your projects in less time.

## Official documentation

The documentation is available on [the Themosis framework website](http://framework.themosis.com/docs/).

---

### Development

The framework was created by [Julien Lambé](http://www.themosis.com/), who continues to lead the development.

### Contributing to Themosis

All issues and pull requests should be filled on the [themosis/framework](https://github.com/themosis/framework/issues) repository.

### License

The Themosis framework is open-source software licensed under [GPL-2+ license](http://www.gnu.org/licenses/gpl-2.0.html).
