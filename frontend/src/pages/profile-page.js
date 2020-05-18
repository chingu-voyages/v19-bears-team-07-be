import React from "react"

import Layout from "../components/Layout/Layout"
import SEO from "../components/Seo"

import { EditDevForm } from "../components/EditDevForm/EditDevForm"
import { Container } from "reactstrap"
import { UserContext } from "../shared/UserContext"
import { mapUser } from "../shared/mappers"
import { fetchUser } from "../shared/fetch"

const initial = {
  name: "",
  bio: "",
  image: "",
  github: "",
  twitter: "",
  linkedin: "",
}

const ProfilePage = () => {
  const { userId, loggedIn } = React.useContext(UserContext)

  const [initialValues, setInitialValues] = React.useState(initial)
  const [refreshCount, setRefreshCount] = React.useState(0)

  React.useEffect(() => {
    ;(async () => {
      if (loggedIn && userId) {
        const user = await mapUser(await fetchUser(userId))
        console.log(user)
        setInitialValues(user)
      }
    })()
  }, [refreshCount, userId, loggedIn])

  if (!loggedIn || !userId) {
    // If we're not logged in, this page doesn't display. Or it should show an error
    return <Layout></Layout>
  }

  return (
    <Layout>
      <SEO title="Profile Page" />
      <h1>profile page</h1>
      <Container>{renderImage()}</Container>
      <div>
        <EditDevForm
          initialValues={initialValues}
          userId={userId}
          onSubmit={() => {
            setRefreshCount(old => old + 1)
          }}
        ></EditDevForm>
      </div>
    </Layout>
  )

  function renderImage() {
    if (initialValues.image) {
      return (
        <img
          src={initialValues.image}
          alt={"Your profile"}
          width={200}
          height={200}
        ></img>
      )
    } else {
      return null
    }
  }
}

export default ProfilePage