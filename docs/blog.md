# Blog

### Blog
- id: Unique[int] - index
- title: str
- date: datetime
- tags: List[Tag]
- category: Category
- author : User
- content: str
- comments: List[Comment]

### User | Author
- id: Unique[int] - index
- name: str
- email: str
- password: str (bcrypt)
- avatar: str

### Category
Add them from admin panel
- name: str
- slug: str

### Tag
- slug: str - index
- name: str

### Comment
- id: Unique[int] - index
- user: User
- content: str
- blog: Blog

## Contracts (Requests/Responses)
```
/login
- POST: Credentials
email: str
password: str

{
    token: str
}
```
```
/register
- POST: Register
name: str
email: str
password: str

{
    token: str
}
```
```
/me
- GET: User

{
    name: str
    email: str
    avatar: str
}
```
```
/categories
- GET: List[Category]
[
    {
        name: str
        slug: str
    }
]
```
```
/blog
- GET: List[Blog]
[
    {
        id: int
        title: str
        date: datetime
        tags: List[Tag]
        category: Category
        author: User
    }
]
```
```
/blog/{id}
- GET: Blog
{
    id: int
    title: str
    date: datetime
    tags: List[Tag]
    category: Category
    author : User
    content: str
    comments: List[Comment]
}

- POST: Blog
title: str
tags: List[str]
category: Category - selected from categories
content: str

201 Created
{
    id: int
    title: str
    date: datetime
    tags: List[Tag]
    category: Category
    author : User
    content: str
    comments: List[Comment]
}

```

```
/blog/{id}/comments
- GET: *Websocket*

- POST: Comment
content: str
```




