import streamlit as st
import requests
import json

st.set_page_config(page_title="Query Copilot 🤖", layout="centered")
st.title("Query Copilot 📈")
st.caption("Ask in English, get answers from AWS Athena ✨")

query = st.text_input("Enter your question:", placeholder="e.g., show me all login events")

if st.button("Ask"):
    if not query:
        st.warning("Please enter a question.")
    else:
        with st.spinner("Thinking..."):
            try:
                response = requests.post(
                    "http://backend:8000/ask",  # points to Docker service name
                    headers={"Content-Type": "application/json"},
                    data=json.dumps({"question": query})
                )
                data = response.json()
                if "result" in data:
                    st.success("Here's what we found:")
                    st.dataframe(data["result"])
                elif "error" in data:
                    st.error(f"Error: {data['error']}")
                else:
                    st.warning("No data returned.")
            except Exception as e:
                st.error(f"Request failed: {str(e)}")
