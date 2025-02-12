/*
This script replaces most references to images on a dead domain with placeholders that won't resolve in DNS.
This may reduce false positives from Google Safe Browsing when the target domain is marked as unsafe.
By using nxdomain.lemmy.world in the replacement this allows to easily determine the original URL if desired.
*/

update person
set avatar = regexp_replace(person.avatar, '(://wayfarershaven\.eu)(/)', '\1.nxdomain.lemmy.world\2')
where person.avatar like '%://wayfarershaven.eu/%';

update person
set banner = regexp_replace(person.banner, '(://wayfarershaven\.eu)(/)', '\1.nxdomain.lemmy.world\2')
where person.banner like '%://wayfarershaven.eu/%';

update person
set bio = regexp_replace(person.bio, '(://wayfarershaven\.eu)(/)', '\1.nxdomain.lemmy.world\2')
where person.bio like '%://wayfarershaven.eu/%';

update post
set thumbnail_url = regexp_replace(post.thumbnail_url, '(://wayfarershaven\.eu)(/)', '\1.nxdomain.lemmy.world\2')
where post.thumbnail_url like '%://wayfarershaven.eu/%';

update post
set url = regexp_replace(post.url, '(://wayfarershaven\.eu)(/)', '\1.nxdomain.lemmy.world\2')
where post.url like '%://wayfarershaven.eu/%';

update post
set body = regexp_replace(post.body, '(://wayfarershaven\.eu)(/)', '\1.nxdomain.lemmy.world\2')
where post.body like '%://wayfarershaven.eu/%';

update comment
set content = regexp_replace(comment.content, '(://wayfarershaven\.eu)(/)', '\1.nxdomain.lemmy.world\2')
where comment.content like '%://wayfarershaven.eu/%';

update community
set icon = regexp_replace(community.icon, '(://wayfarershaven\.eu)(/)', '\1.nxdomain.lemmy.world\2')
where community.icon like '%://wayfarershaven.eu/%';

update community
set banner = regexp_replace(community.banner, '(://wayfarershaven\.eu)(/)', '\1.nxdomain.lemmy.world\2')
where community.banner like '%://wayfarershaven.eu/%';

update community
set description = regexp_replace(community.description, '(://wayfarershaven\.eu)(/)', '\1.nxdomain.lemmy.world\2')
where community.description like '%://wayfarershaven.eu/%';
