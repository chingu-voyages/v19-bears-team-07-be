/**
 * This file exports the functions that map the data retrieved from the backend to the
 * data used in the views.
 */

export const mapApp = appData => {
  const { name, description, img, app_url, github_url, id } = appData

  return {
    name: name,
    description: description,
    image: img,
    appUrl: app_url,
    githubUrl: github_url,

    url: `/apps/${id}`,
    imageUrl: img
      ? ""
      : "https://brandthunder.com/wp/wp-content/uploads/2012/07/Facebook-skins-post.png",
  }
}