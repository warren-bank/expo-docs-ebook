const filepath_raw_navigation_array  = process.argv[2]
const filepath_navigation_sections   = process.argv[3]
const filepath_navigation_data       = process.argv[4]
const filepath_navigation_order      = process.argv[5]

const navdata = {
  raw_arr:  require(filepath_raw_navigation_array),
  sections: require(filepath_navigation_sections),
  dir_map:  require(filepath_navigation_data),
  dir_hash: {}
}

const navorder = require(filepath_navigation_order)

const navlinks = []
const navlinks_sorted = []

// shape of output:
/* [
 *   {name: "descriptive name mapped to dirname", href: "url or empty", posts: [
 *     {name: "title", href: "pages/abc/def.md"}
 *   ]}
 * ]
 */
const process_raw_arr = function() {
  const href_regex = new RegExp('^pages/([^/]+)/(([^/]+))$')

  navdata.raw_arr.map(([href, title]) => {
    let match = href_regex.exec(href)
    if (!Array.isArray(match)) {
      navlinks.push({name: title, href})
    }
    else {
      let dirname = match[1]
      let dir_obj

      if (navdata.dir_hash[dirname]) {
        dir_obj = navdata.dir_hash[dirname]
      }
      else {
        dir_obj = {
          name: (navdata.dir_map[dirname] || title),
          href: '',
          posts: []
        }
        navdata.dir_hash[dirname] = dir_obj
        navlinks.push(dir_obj)
      }
      dir_obj.posts.push({name: title, href})
    }
  })
}

const update_navigation_data = function() {
  const fs  = require('fs')
  const txt = 'module.exports = ' + JSON.stringify(navlinks, null, 2)

  fs.writeFileSync(filepath_navigation_data, txt)
}

// shape of output:
/* [
 *   {group: "name", categories: [
 *     {category: "name", links: [
 *       {name: "title", href: "pages/abc/def.md"}
 *     ]}
 *   ]}
 * ]
 */
const sort_navigation_data = function() {
  const filtered_navlinks = []

  const default_dirname = 'introduction'
  const default_dir_obj = navdata.dir_hash[default_dirname]

  navlinks.forEach(dir_obj => {
    if (dir_obj.href)
      default_dir_obj.posts.push(dir_obj)
    else
      filtered_navlinks.push(dir_obj)
  })

  const find_dir_reference = function(dir_obj) {
    let name    = dir_obj.name
    let section = navdata.sections.find(sect => sect.name === name)
    let reference

    // shouldn't be necessary, but it is..
    if (section && section.reference) {
      reference = section.reference
    }
    else {
      name = name.toUpperCase().replace(/[\s]+/g, '_')
      if (navorder[name])
        reference = navorder[name]
    }

    return reference
  }

  const rank_posts_in_dir = function(dir_obj, reference) {
    if (!reference)
      reference = find_dir_reference(dir_obj)

    if (Array.isArray(reference)) {
      dir_obj.posts.forEach(post => {
        post.rank = reference.indexOf(post.name)
      })
    }

    const intro = 'overview'

    dir_obj.posts.sort((p1, p2) => {
      let r1 = p1.rank
      let r2 = p2.rank

      let n1 = p1.name.toLowerCase()
      let n2 = p2.name.toLowerCase()

      if (n1 === intro)
        return -1

      if (n2 === intro)
        return 1

      if ((r1 >= 0) && (r2 === -1))
        return -1

      if ((r2 >= 0) && (r1 === -1))
        return 1

      if ((r1 >= 0) && (r2 >= 0))
        return (r1 < r2)
          ? -1
          : (r1 === r2)
            ? 0
            : 1

      if ((r1 === -1) && (r2 === -1))
        return (n1 < n2)
          ? -1
          : (n1 === n2)
            ? 0
            : 1

      return 0
    })
  }

  const rank_dirs = function() {
    const fake_dir_obj = {posts: filtered_navlinks}
    const {ROOT}       = navorder

    rank_posts_in_dir(fake_dir_obj, ROOT)
  }

  const organize_dirs_by_category_groupings = function() {
    const {GROUPS} = navorder
    let active_group_name, active_group_categories

    filtered_navlinks.forEach(dir_obj => {
      let category_name  = dir_obj.name
      let category_links = dir_obj.posts

      let group_name = GROUPS[category_name]
      if (!group_name)
        throw new Error('group name not found for category: ' + category_name)

      if (group_name !== active_group_name) {
        active_group_name       = group_name
        active_group_categories = []

        navlinks_sorted.push({
          group:      active_group_name,
          categories: active_group_categories
        })
      }

      active_group_categories.push({
        category: category_name,
        links:    category_links
      })
    })
  }

  const process_data = function() {
    filtered_navlinks.forEach(dir_obj => {
      rank_posts_in_dir(dir_obj)
    })

    rank_dirs()

    organize_dirs_by_category_groupings()
  }

  process_data()
}

const output_sorted_navigational_data_in_markdown = function() {
  navlinks_sorted.forEach(group => {
    console.log(`* ${group.group}`)

    group.categories.forEach(category => {
      console.log(`  * ${category.category}`)

      category.links.forEach(page => {
        console.log(`    * [${page.name}](${page.href})`)
      })
    })
  })
}

process_raw_arr()
update_navigation_data()
sort_navigation_data()

//  console.log(JSON.stringify(navlinks_sorted, null, 2))
//  process.exit(0)

output_sorted_navigational_data_in_markdown()
