#!/usr/bin/perl
use autodie;
use strict;
use Cwd;
use Switch;
use XML::Simple;
use JSON;
use LWP::Simple;
use File::Copy;
use URI;

my $GIT_ENABLED = 1;

my %REPOS = (
	githubxbmcaddons => {
		type => 'githubrepo',
		url => 'https://api.github.com/users/XBMC-Addons/repos',
		ignore => {
			'media.backgrounds.weather' => 1,
		}
	},
	xbmcplugins => {
		type => 'git',
		branch => 'eden',
		url => 'git://xbmc.git.sourceforge.net/gitroot/xbmc/plugins',
		ignore => {
			'plugin.video.eyetv.parser' => 1,
			'plugin.video.furk' => 1,
			'plugin.video.drnu' => 1,
			'plugin.video.rbk.no' => 1,
			'plugin.video.servustv' => 1,
			'plugin.video.pakee' => 1,
			'plugin.video.tageswebschau' => 1,
			'plugin.video.sarpur' => 1,
			'plugin.video.nederland24' => 1,
			'plugin.video.circuitboard' => 1,
			'plugin.audio.vorleser_net' => 1,
			'plugin.video.mediathek' => 1,
			'plugin.audio.einslive_de' => 1,
			'plugin.video.arte_tv' => 1,
			'plugin.video.bild_de' => 1,
			'plugin.video.lachschon_de' => 1,
			'plugin.video.dtm_tv' => 1,
			'plugin.video.n24_de' => 1,
			'plugin.video.chip_de' => 1,
			'plugin.video.filmstarts_de' => 1,
			'plugin.video.fernsehkritik_tv' => 1,
			'plugin.video.sevenload_de' => 1,
			'plugin.video.giga_de' => 1,
			'plugin.video.drdish-tv_de' => 1,
			'plugin.video.zdf_de_lite' => 1,
			'plugin.video.dr.dk.bonanza' => 1,
			'plugin.video.tvvn' => 1,
			'plugin.video.gamestar' => 1,
			'plugin.video.arretsurimages' => 1,
			'plugin.video.nrk' => 1,
			'plugin.video.dr.dk.live' => 1,
			'plugin.video.tv3play.dk' => 1,
			'plugin.video.eredivisie-live' => 1,
			'plugin.video.tapetv' => 1,
			'plugin.video.dmax' => 1,
			'plugin.video.visir' => 1,
			'plugin.video.hwclips' => 1,
			'plugin.audio.radioma' => 1,
			'plugin.video.ziggo.tv' => 1,
			'plugin.audio.sverigesradio' => 1,
			'plugin.video.svtplay' => 1,
			'plugin.video.spiegelonline' => 1,
			'plugin.audio.radio_de' => 1,
			'plugin.video.day9' => 1,
			'plugin.video.dr.dk.podcast' => 1,
			'plugin.audio.abradio.cz' => 1,
			'plugin.video.tv2regionerne.dk' => 1,
			'plugin.video.dmi.dk' => 1,
			'plugin.video.tagesschau' => 1,
			'plugin.video.nos' => 1,
			'plugin.video.tv2.dk' => 1,
			'plugin.video.gamereactor.dk' => 1,
			'plugin.video.gaffa.tv' => 1,
			'plugin.video.4players' => 1,
			'plugin.video.borsentv.dk' => 1,
			'plugin.audio.dr.dk.netradio' => 1,
			'plugin.video.gametest.dk' => 1,
			'plugin.video.tvkaista' => 1,
			'plugin.video.leafstv' => 1,
			'plugin.audio.mozart' => 1,
			'plugin.video.news.tv2.dk' => 1,
			'plugin.video.fox.news' => 1,
			'plugin.video.s04tv' => 1,
			'plugin.video.zapiks' => 1,
			'plugin.video.yousee.tv' => 1,
		}
	},
	xbmcscrapers => {
		type => 'git',
		branch => 'eden',
		url => 'git://xbmc.git.sourceforge.net/gitroot/xbmc/scrapers',
		ignore => {
			'metadata.douban.com' => 1,
			'metadata.cinemagia.ro' => 1,
			'metadata.cinemarx.ro' => 1,
			'metadata.common.ofdb.de' => 1,
			'metadata.mtime.com' => 1,
			'metadata.port.hu' => 1,
			'metadata.sratim.co.il' => 1,
			'metadata.filmweb.pl' => 1,
			'metadata.videobuster.de' => 1,
			'metadata.artists.yoyo.pl' => 1,
			'metadata.albums.merlin.pl' => 1,
			'metadata.worldart.ru' => 1,
			'metadata.tv.movieplayer.it' => 1,
			'metadata.serialzone.cz' => 1,
			'metadata.tv.daum.net' => 1,
			'metadata.tw.movie.yahoo.com' => 1,
			'metadata.m1905.com' => 1,
			'metadata.mymovies.dk' => 1,
			'metadata.kinobox.cz' => 1,
			'metadata.movie.daum.net' => 1,
			'metadata.he.israel-music.co.il' => 1,
			'metadata.disneyinfo.nl' => 1,
			'metadata.common.movie.daum.net' => 1,
			'metadata.filmbasen.dagbladet.no' => 1,
			'metadata.bestanime.co.kr' => 1,
			'metadata.artists.top100.cn' => 1,
			'metadata.artists.1ting.com' => 1,
			'metadata.artists.naver.com' => 1,
			'metadata.albums.naver.com' => 1,
			'metadata.artists.daum.net' => 1,
			'metadata.albums.top100.cn' => 1,
			'metadata.albums.daum.net' => 1,
			'metadata.albums.1ting.com' => 1,
			'metadata.7176.com' => 1,
			'metadata.ptgate.pt' => 1,
			'metadata.cinefacts.de' => 1,
			'metadata.ofdb.de' => 1,
			'metadata.kino.de' => 1,
			'metadata.atmovies.com.tw' => 1,
			'metadata.kinopoisk.ru' => 1,
			'metadata.filmstarts.de' => 1,
			'metadata.cine.passion-xbmc.org' => 1,
			'metadata.moviemaze.de' => 1,
			'metadata.filmdelta.se' => 1,
			'metadata.movieplayer.it' => 1,
			'metadata.moviemeter.nl' => 1,
			'metadata.mymovies.it' => 1,
		}
	},
	xbmcscreensavers => {
		type => 'git',
		branch => 'eden',
		url => 'git://xbmc.git.sourceforge.net/gitroot/xbmc/screensavers',
		ignore => {
		}
	},
	xbmcvisualizations => {
		type => 'git',
		branch => 'eden',
		url => 'git://xbmc.git.sourceforge.net/gitroot/xbmc/visualizations',
		ignore => {
		}
	},
	xbmcscripts => {
		type => 'git',
		branch => 'eden',
		url => 'git://xbmc.git.sourceforge.net/gitroot/xbmc/scripts',
		ignore => {
		}
	},
	xbmcwebinterfaces => {
		type => 'git',
		branch => 'eden',
		url => 'git://xbmc.git.sourceforge.net/gitroot/xbmc/webinterfaces',
		ignore => {
		}
	},
	xbmcskins => {
		type => 'git',
		url => 'git://xbmc.git.sourceforge.net/gitroot/xbmc/skins',
		branch => 'eden',
		ignore => {
			'skin.aeon.nox' => 1,
			'skin.back-row' => 1,
			'skin.confluence-vertical' => 1,
			'skin.jx720' => 1,
			'skin.mediastream_redux' => 1,
			'skin.neon' => 1,
			'skin.night' => 1,
			'skin.pm3-hd' => 1,
			'skin.quartz' => 1,
			'skin.rapier' => 1,
			'skin.shade' => 1,
			'skin.simplicity' => 1,
			'skin.slik' => 1,
			'skin.transparency' => 1,
			'skin.xperience' => 1,
			'skin.xperience-more' => 1,
			'skin.xtv-saf' => 1,
		}
	},
	moreginger => {
		type => 'git',
		url => 'https://github.com/moreginger/xbmc-plugin.video.ted.talks.git',
		ignore => {
		}
	},
	dethfeet => {
		type => 'git',
		url => 'https://github.com/dethfeet/plugin.video.kidsplace.git',
		ignore => {
		}
	},
	eldorado => {
		type => 'git',
		url => 'https://github.com/Eldorados/eldorado-xbmc-addons.git',
		ignore => {
			'repository.eldorado' => 1,
			'repo' => 1,
		}
	},
	nuka => {
		type => 'svn',
		url => 'http://xbmc-addons.googlecode.com/svn/addons/',
		ignore => {
			'plugin.audio.listenliveeu' => 1,
			'plugin.video.nos.journaal' => 1,
			'plugin.video.sarpur' => 1,
			'plugin.video.videomonkey' => 1,
			'repository.googlecode.xbmc-addons' => 1,
		}
	},
	maxmustermann => {
		type => 'svn',
		url => 'http://xbmc-development-with-passion.googlecode.com/svn/branches/addons/',
		ignore => {
			'repository.MaxMustermann.xbmc' => 1,
		}
	},
	sparetime => {
		type => 'svn',
		url => 'http://sparetime.googlecode.com/svn/trunk/addons/',
		ignore => {
			'repository.googlecode.sparetime' => 1,
		}
	},
	orokara => {
		type => 'svn',
		url => 'http://xbmc-addon-repository.googlecode.com/svn/trunk/',
		ignore => {
			'plugin.audio.plex.itunes' => 1,
		}
	},
	ize => {
		type => 'svn',
		url => 'http://izexbmcaddons.googlecode.com/svn/addons/',
		ignore => {
			'plugin.video.gametrailers' => 1,
		}
	},
	aj => {
		type => 'svn',
		url => 'http://apple-tv2-xbmc.googlecode.com/svn/trunk/addons/',
		ignore => {
			'plugin.video.dramacrazy' => 1,
			'repository.googlecode.apple-tv2-xbmc' => 1,
			'plugin.video.filipinotv' => 1,
			'plugin.video.filmibynature' => 1,
			'plugin.video.TVonDesiZone' => 1,
			'plugin.video.willowtv' => 1,
		}
	},
	dandar3 => {
		type => 'svn',
		url => 'http://dandar3-xbmc-addons.googlecode.com/svn/trunk/addons/',
		ignore => {
		}
	},
	bluecop => {
		type => 'svn',
		url => 'http://bluecop-xbmc-repo.googlecode.com/svn/trunk/',
		ignore => {
			'plugin.video.baeble' => 1,
			'repository.bluecop.xbmc-plugins' => 1,
		}
	},
	divingmule => {
		type => 'svn',
		url => 'http://divingmules-repo.googlecode.com/svn/trunk/',
		ignore => {
		}
	},
	anarchintosh => {
		type => 'svn',
		url => 'http://anarchintosh-projects.googlecode.com/svn/addons',
		ignore => {
			'plugin.download.irfree' => 1,
			'plugin.download.oneddl' => 1,
			'repository.googlecode.anarchintosh-projects' => 1,
		}
	},
	andrepl => {
		type => 'http',
		url => 'http://brosemer.org/~odin/xbmc-addons/',
		ignore => {
			'plugin.video.canada.on.demand' => 1,
			'repository.andrepl' => 1,
		}
	},
	bstrdsmkr => {
		type => 'http',
		url => 'http://repo.gosub.dk/bstrdsmkr/repo/',
		ignore => {
			'repository.bstrdsmkr' => 1,
		},
		zips => 1
	},
);

my $MYGIT = cwd() . '/xbmc-repository-mirror';
mkdir $MYGIT unless -e $MYGIT;
my $LOCAL_REPOS = cwd() . '/repos';
mkdir $LOCAL_REPOS unless -e $LOCAL_REPOS;

my $svn   = `which svn`   or die "svn COMMAND NOT FOUND! EXITING.\n";
my $git   = `which git`   or die "git COMMAND NOT FOUND! EXITING.\n";
my $zip   = `which zip`   or die "zip COMMAND NOT FOUND! EXITING.\n";
my $wget  = `which wget`  or die "wget COMMAND NOT FOUND! EXITING.\n";

foreach my $name (keys %REPOS) {
	print "$name - $REPOS{$name}{url}\n";
	my $repo_path = $LOCAL_REPOS . '/' . $name;

	switch ($REPOS{$name}{type}) {
		case 'git' {
			do_git( $name, $repo_path );
		}
		case 'githubrepo' {
			do_githubrepo( $name, $repo_path, $name );
		}
		case 'svn' {
			do_svn( $name, $repo_path );
		}
		case 'http' {
			do_http( $name, $repo_path );
		}
	}

	####################################################
	# Extra files that should be added to existing addon

	# get divingmules community xml files for live streams
	switch ($name) {
		case 'divingmule' {
			do_svn( 'http://community-links.googlecode.com/svn/trunk/', $LOCAL_REPOS . '/divingmule/plugin.video.live.streams/xml_files');
		}
	}
	####################################################


	opendir my($dhandle), $repo_path;
	while ( readdir($dhandle) ) {
		my $plugin_name = $_;

		next if $plugin_name =~ /^\..*$/;
		next unless -d "$repo_path/$plugin_name";
		next if $REPOS{$name}{ignore}{$plugin_name};

		# extract addon.xml from zip since most people dont already do that
		if ( $REPOS{$name}{zips} ) {
			my $latest_addon_zip_file = `ls -1r $repo_path/$plugin_name/*.zip | head -1`;
			if ( chomp $latest_addon_zip_file ) {
				print "...extracting addon.xml from $latest_addon_zip_file";
				`unzip -o -j -d $repo_path/$plugin_name $latest_addon_zip_file $plugin_name/addon.xml`;
				print "...DONE.\n";
			}
		}

		next unless -f "$repo_path/$plugin_name/addon.xml";
		
		print "...get addon version...";
		my $addon = XMLin( "$repo_path/$plugin_name/addon.xml" );
		my $version = $addon->{version};
		print $version;
		print "...DONE.\n";

		if ( $REPOS{$name}{zips} ) { # repo already zip'd
			print "...rsync $repo_path/$plugin_name to $MYGIT/$plugin_name";
			`rsync -a $repo_path/$plugin_name $MYGIT/`;
			print "...DONE.\n";
		} else {
			no autodie; mkdir "$MYGIT/$plugin_name"; use autodie;
			my $olddir = cwd();
			chdir $repo_path;
			no autodie; unlink( "$MYGIT/$plugin_name/$plugin_name-$version.zip" ); use autodie;
			if ( ! -f "$MYGIT/$plugin_name/$plugin_name-$version.zip" ) {
				print "...zip $repo_path/$plugin_name to $MYGIT/$plugin_name";
				`zip -r $MYGIT/$plugin_name/$plugin_name-$version.zip $plugin_name --exclude=*.svn* --exclude=*.git*`;
				print "...DONE.\n";
			}
			chdir $olddir;
			copy( "$repo_path/$plugin_name/addon.xml", "$MYGIT/$plugin_name/addon.xml" );
			if ( -f "$repo_path/$plugin_name/icon.png" ) {
				copy( "$repo_path/$plugin_name/icon.png", "$MYGIT/$plugin_name/icon.png" );
			}
		}
	}
	closedir $dhandle;

	print "=======\n";
}

chdir $MYGIT;
print "\n\n\n";
print "Running addons_xml_generator.py...";
`python addons_xml_generator.py`;
print "DONE.\n";

exit unless $GIT_ENABLED;

print "Adding files to git...";
`git add . -A`;
print "DONE.\n";
print "Commiting to git...";
`git commit -m "yea yea"`;
print "DONE.\n";
print "Pushing to git...";
`git push`;
print "DONE.\n";


# clone all repos for a user from github
sub do_githubrepo {
        my $name = shift;
        my $repo_path = shift;
	my $repo_name = shift;

	my $url = $REPOS{$name}{url};

        # If directory doesnt exist then create it
        if ( ! -d $repo_path ) {
                print "...creating directory for $repo_path";
                mkdir $repo_path;
                print "...DONE.\n";
        }

        # get all users repos
        my $json = get( $url ) or die "$!: could not download $url!\n"; 

	my $github_repos = decode_json $json;
	foreach my $github_repo ( @{$github_repos} ) {
		my $github_repo_name = $github_repo->{name};
		my $github_repo_url = $github_repo->{git_url};

		next if $REPOS{$repo_name}{ignore}{$github_repo_name};

		do_git($github_repo_url, "$repo_path/$github_repo_name");
	}
}


sub do_git {
        my $name = shift;
        my $repo_path = shift;

	my $url = $REPOS{$name}{url};
	my $branch = $REPOS{$name}{branch} ? " -b " . $REPOS{$name}{branch} : "";
        my $cmd = 'pull';
        # If directory doesnt exist then create it and checkout
        if ( ! -d $repo_path ) {
                print "...creating directory $repo_path";
                mkdir $repo_path;
                print "...DONE.\n";
                $cmd = 'clone';
        }

        print "...git $cmd $branch $url\n";
        my $ret;
        if ( $cmd eq 'clone' ) {
                $ret = `git $cmd $branch $url $repo_path` or die "git $cmd error: $ret\n";
        } else {
                my $olddir = cwd();
                chdir $repo_path;
                $ret = `git $cmd` or die "git $cmd error: $ret\n";
                chdir $olddir;
        }
        print "...DONE.\n";
}

sub do_svn {
	my $name = shift;
	my $repo_path = shift;

	my $url = $REPOS{$name}{url};
	my $cmd = 'update';
	# If directory doesnt exist then create it and checkout
	if ( ! -d $repo_path ) {
		print '...creating directory';
		mkdir $repo_path;
		print "...DONE.\n";
		$cmd = 'checkout';
	}

	print "...svn $cmd";
	my $ret;
	$ret = `svn $cmd $url $repo_path` or die "svn $cmd error: $ret\n";
	print "...DONE.\n";
}

sub do_http {
	my $name = shift;
	my $repo_path = shift;

	my $url = $REPOS{$name}{url};
	my $cmd = 'update';
	# If directory doesnt exist then create it and checkout
	if ( ! -d $repo_path ) {
		print '...creating directory';
		mkdir $repo_path;
		print "...DONE.\n";
		$cmd = 'initial mirror';
	}

	my $path_count = ((URI->new( $url )->path =~ tr/\///) - 1);

	print "...http $cmd";
	`wget --quiet --mirror -erobots=off --no-parent --no-host-directories --cut-dirs=$path_count --directory-prefix=$repo_path $url`;
	print "...DONE.\n";
}





