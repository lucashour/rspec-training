FactoryBot.define do
  factory :user do
    auth_token { SecureRandom.hex }
    email      { Faker::Internet.email }
    password   { SecureRandom.uuid }

    # Definición de atributos transitorios o transients
    transient do
      posts_count { 2 }
    end

    # Implementación de rasgos o traits
    trait :with_posts do
      after(:create) do |user, options| # hook
        # Podemos acceder a un transient a través de options.
        # Aprovechamos esto para hacer dinámica la cantidad de posts
        # de un usuario cuando le agregamos el rasgo o trait 'with_posts'.
        create_list(:post, options.posts_count, user: user)
      end
    end

    # Implementación de herencia
    factory :admin_user do
      role { User.roles[:admin] }
    end

    factory :regular_user do
      role { User.roles[:regular] }
    end
  end
end

# Crear un usuario
# -> create(:user)
# Crear un usuario admistrador
# -> create(:admin_user)
# Crear un usuario con rasgo/trait 'with_posts' para que tenga 2 posts
# -> create(:user, :with_posts)
# Crear un usuario con rasgo/trait 'with_posts' con 5 posts
# -> create(:user, :with_posts, posts_count: 5)
# Crear un usuario con rasgo/trait 'with_posts' y un email fijo
# -> create(:user, :with_posts, email: 'bruce.wayne@mail.com')
# Crear 3 usuarios
# -> create_list(:user, 3)
# Crear 3 usuarios admistradores
# -> create_list(:admin_user, 3)
