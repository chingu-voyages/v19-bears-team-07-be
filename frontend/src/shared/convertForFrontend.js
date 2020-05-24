// use `import * as forFrontend from "./convertForFrontend"

export const convertApp = ({
  name,
  description,
  img,
  app_url,
  github_url,
  id,
  user_id,
}) => ({
  name,
  description,
  image: img,
  appUrl: app_url,
  githubUrl: github_url,
  userId: user_id,

  url: `/apps/${id}`,
  manageUrl: `/manage-apps/${id}/edit`,
  imageUrl: img
    ? ""
    : "https://brandthunder.com/wp/wp-content/uploads/2012/07/Facebook-skins-post.png",
})

export const convertUser = userData => {
  const {
    name,
    img,
    is_dev,
    dev_bio,
    dev_twitter,
    dev_github,
    dev_linkedin,
    dev_portfolio,
    id,
  } = userData

  return {
    name: name ? name : "",
    image: img
      ? img
      : "https://www.kirkleescollege.ac.uk/wp-content/uploads/2015/09/default-avatar.png",
    dev: is_dev ? is_dev : "",
    bio: dev_bio ? dev_bio : "",
    twitter: dev_twitter ? dev_twitter : "",
    github: dev_github ? dev_github : "",
    linkedin: dev_linkedin ? dev_linkedin : "",
    website: dev_portfolio ? dev_portfolio : "",
    url: `portfolios/${id}`,
  }
}
