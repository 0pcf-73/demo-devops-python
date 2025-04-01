import json
from django.urls import reverse
from rest_framework.test import APITestCase
from .models import User


class TestUserView(APITestCase):

    def setUp(self):
        user = User(name='Test1', dni='09876543210')
        user.save()
        self.url = reverse("users-list")
        self.data = {'name': 'Test2', 'dni': '09876543211'}


    def test_post(self):
        response = self.client.post(self.url, self.data, format='json')
        self.assertEqual(response.status_code, 201)

        data = json.loads(response.content)
        # Verifica que 'dni' y 'name' sean los esperados
        self.assertEqual(data.get('dni'), "09876543211")
        self.assertEqual(data.get('name'), "Test2")
        # Verifica que 'id' exista y sea un número entero
        self.assertIn('id', data)
        self.assertIsInstance(data['id'], int)

        # Además, comprueba que se haya creado el usuario
        self.assertEqual(User.objects.count(), 2)


    def test_get_list(self):
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(json.loads(response.content)), 1)


    def test_get(self):
        response = self.client.get(self.url + '1/')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(
            json.loads(response.content),
            {"id": 1, "name": "Test1", "dni": "09876543210"}
        )